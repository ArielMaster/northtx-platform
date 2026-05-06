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

  def create_session
    ensure_checkout_data!
    # @plan = @current_plan
    @plan = @plan

    checkout_data = session[:checkout]

    stripe_session = Stripe::Checkout::Session.create(
      mode: "payment",
      customer_email: checkout_data["email"],
      line_items: [ {
        price_data: {
          currency: "usd",
          product_data: { name: @plan.name },
          unit_amount: @plan.price_cents
        },
        quantity: 1
      } ],
      success_url: success_checkouts_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: review_checkouts_url
    )

    # store minimal data keyed by stripe_session.id
    Rails.cache.write("checkout:#{stripe_session.id}", {
      plan_id: @plan.id,
      name: checkout_data["name"],
      email: checkout_data["email"],
      phone: checkout_data["phone"]
    }, expires_in: 2.hours)

    redirect_to stripe_session.url, allow_other_host: true
  end

  def success
    @session_id = params[:session_id]
    @receipt = Receipt.find_by(stripe_session_id: @session_id)

    unless @receipt
      session_data = Rails.cache.read("checkout:#{@session_id}")
      plan = Plan.find(session_data[:plan_id])

      @receipt = Receipt.create!(
        user_id: current_user.id,
        plan_id: plan.id,
        stripe_session_id: @session_id,
        plan_name: plan.name,
        amount_cents: plan.price_cents,   # ← FIXED
        name: session_data[:name],
        email: session_data[:email]
      )
    end
  end

  private

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
