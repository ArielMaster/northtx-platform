# app/controllers/stripe_controller.rb
class StripeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)

    event = nil

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      render json: { error: "Invalid payload" }, status: 400 and return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: "Invalid signature" }, status: 400 and return
    end

    case event.type
    when "checkout.session.completed"
      session = event.data.object
      handle_checkout_completed(session)
    end

    render json: { status: "success" }
  end

  private

  def handle_checkout_completed(stripe_session)
    cache_key = "checkout:#{stripe_session.id}"
    data = Rails.cache.read(cache_key)
    return unless data.present?

    email = data[:email]
    name  = data[:name]
    plan  = Plan.find_by(id: data[:plan_id])
    return unless plan

    user = User.find_or_initialize_by(email: email)

    new_user = user.new_record?

    if new_user
      # temporary random password; user will set their own via email
      user.name = name
      user.password = SecureRandom.hex(16)
      user.save!
    end

    receipt = Receipt.find_or_create_by!(stripe_session_id: stripe_session.id) do |r|
      r.user          = user
      r.plan          = plan
      r.amount_cents  = stripe_session.amount_total
      r.currency      = stripe_session.currency
    end

    # send receipt email
    ReceiptMailer.with(receipt: receipt).send_receipt.deliver_later

    # send set password email if new user
    if new_user
      UserMailer.with(user: user).set_password_instructions.deliver_later
    end

    Rails.cache.delete(cache_key)
  end
end
