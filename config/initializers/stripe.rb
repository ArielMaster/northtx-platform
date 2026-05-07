# config/initializers/stripe.rb
# Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)

# Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key) || ENV["STRIPE_SECRET_KEY"]

# Production
# Rails.configuration.stripe = {
#   publishable_key: ENV["STRIPE_PUBLISHABLE_KEY"],
#   secret_key: ENV["STRIPE_SECRET_KEY"]
# }

# Stripe.api_key = Rails.configuration.stripe[:secret_key]

Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

# Helpful log message for debugging, but avoid raising during build.
if Rails.env.production? && Stripe.api_key.blank?
  # Avoid raising during assets:precompile; only warn.
  if defined?(Rails) && Rails.respond_to?(:logger) && !ENV["CI"]
    Rails.logger.warn("STRIPE_SECRET_KEY is not set. Stripe calls will fail without it.")
  end
end
