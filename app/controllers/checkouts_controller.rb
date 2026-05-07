class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_plan, only: [ :review, :create_session ]


  def info
    session[:checkout] ||= {}
    session[:checkout]["plan_id"] = params[:plan_id] if params[:plan_id].present?

    @plan = Plan.find_by(id: session[:checkout]["plan_id"])
    redirect_to pricing_path, alert: "Invalid plan selected." unless @plan
  end
  # def info
  #   # expects params[:plan_id] from pricing page
  #   session[:checkout] ||= {}
  #   session[:checkout]["plan_id"] = params[:plan_id] if params[:plan_id].present?
  #   redirect_to pricing_path and return unless session[:checkout]["plan_id"]

  #   # @plan is already loaded by load_plan
  # end

  def info_submit
    session[:checkout] ||= {}
    session[:checkout]["name"]  = params[:name]
    session[:checkout]["email"] = params[:email]
    session[:checkout]["phone"] = params[:phone]

    if session[:checkout]["name"].blank? || session[:checkout]["email"].blank?
      flash.now[:alert] = "Name and email are required."
      @plan = Plan.find(session[:checkout]["plan_id"])
      render :info, status: :unprocessable_entity
    else
      redirect_to terms_checkouts_path
    end
  end

  def terms
    ensure_checkout_data!
  end

  def terms_accept
    ensure_checkout_data!

    accepted = ActiveModel::Type::Boolean.new.cast(params[:terms_accepted])
    unless accepted
      flash[:alert] = "You must accept the terms to continue."
      redirect_to terms_checkouts_path and return
    end

    session[:checkout]["terms_accepted"] = true
    redirect_to review_checkouts_path
  end

  def review
    ensure_checkout_data!
    # @plan is already loaded by load_plan
  end

  # def create_session
  #   ensure_checkout_data!
  #   # @plan = @current_plan
  #   @plan = @plan

  #   checkout_data = session[:checkout]

  #   stripe_session = Stripe::Checkout::Session.create(
  #     mode: "payment",
  #     customer_email: checkout_data["email"],
  #     line_items: [ {
  #       price_data: {
  #         currency: "usd",
  #         product_data: { name: @plan.name },
  #         unit_amount: @plan.price_cents
  #       },
  #       quantity: 1
  #     } ],
  #     success_url: success_checkouts_url + "?session_id={CHECKOUT_SESSION_ID}",
  #     cancel_url: review_checkouts_url
  #   )

  #   # store minimal data keyed by stripe_session.id
  #   Rails.cache.write("checkout:#{stripe_session.id}", {
  #     plan_id: @plan.id,
  #     name: checkout_data["name"],
  #     email: checkout_data["email"],
  #     phone: checkout_data["phone"]
  #   }, expires_in: 2.hours)

  #   redirect_to stripe_session.url, allow_other_host: true
  # end

  def create_session
    ensure_checkout_data!
    # @plan is already loaded by load_plan
    checkout_data = session[:checkout]

    stripe_session = Stripe::Checkout::Session.create(
      mode: "payment",
      customer_email: checkout_data["email"],
      line_items: [{
        price_data: {
          currency: "usd",
          product_data: { name: @plan.name },
          unit_amount: @plan.price_cents
        },
        quantity: 1
      }],
      success_url: success_checkouts_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: review_checkouts_url,
      metadata: { plan_id: @plan.id, user_id: current_user&.id }
    )

    # Optional: keep a per-user session copy (not required for production persistence)
    # session["checkout_local:#{stripe_session.id}"] = {
    #   plan_id: @plan.id,
    #   name: checkout_data["name"],
    #   email: checkout_data["email"],
    #   phone: checkout_data["phone"]
    # }

    redirect_to stripe_session.url, allow_other_host: true
  end
  def success
    @session_id = params[:session_id]
    @receipt = Receipt.find_by(stripe_session_id: @session_id)
    return render_success if @receipt

    if @session_id.blank?
      redirect_to pricing_path, alert: "Missing session id." and return
    end

    begin
      stripe_session = Stripe::Checkout::Session.retrieve(@session_id)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.warn("Stripe session retrieve failed: #{e.message}")
      redirect_to pricing_path, alert: "Checkout session not found." and return
    end

    # For Checkout, prefer checking payment_status == "paid"
    if stripe_session.payment_status == "paid" || stripe_session.status == "complete"
      plan_id = stripe_session.metadata["plan_id"]
      user_id = stripe_session.metadata["user_id"]

      plan = Plan.find_by(id: plan_id)
      unless plan
        Rails.logger.warn("Plan not found for plan_id=#{plan_id} from stripe_session=#{@session_id}")
        redirect_to pricing_path, alert: "Plan not found." and return
      end

      user = User.find_by(id: user_id) || User.find_by(email: stripe_session.customer_email)

      @receipt = Receipt.create!(
        user_id: user&.id,
        plan_id: plan.id,
        stripe_session_id: @session_id,
        plan_name: plan.name,
        amount_cents: plan.price_cents,
        name: stripe_session.customer_details&.name || session.dig(:checkout, "name"),
        email: stripe_session.customer_email || session.dig(:checkout, "email")
      )

      render_success
    else
      # Payment not completed yet — show friendly message or ask user to wait/refresh
      redirect_to pricing_path, alert: "Payment not completed yet. If you were charged, wait a minute and refresh this page."
    end
  end

  private

  def render_success
    render :success
  end

  def load_plan
    plan_id = session.dig(:checkout, "plan_id") || params[:plan_id]
    @plan = Plan.find_by(id: plan_id)

    unless @plan
      redirect_to pricing_path, alert: "Invalid plan selected."
    end
  end


  def ensure_checkout_data!
    unless session[:checkout].present? && session[:checkout]["plan_id"].present?
      redirect_to pricing_path, alert: "Your checkout session has expired. Please start again."
    end
  end
end
