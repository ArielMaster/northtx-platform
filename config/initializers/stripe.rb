# config/initializers/stripe.rb
# Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)

# Production
Rails.configuration.stripe = {
  publishable_key: ENV["STRIPE_PUBLISHABLE_KEY"],
  secret_key: ENV["STRIPE_SECRET_KEY"]
}
