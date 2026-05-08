# config/initializers/stripe.rb
Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)

# Production setting
# Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

# Helpful log message for debugging, but avoid raising during build.
if Rails.env.production? && Stripe.api_key.blank?
  # Avoid raising during assets:precompile; only warn.
  if defined?(Rails) && Rails.respond_to?(:logger) && !ENV["CI"]
    Rails.logger.warn("STRIPE_SECRET_KEY is not set. Stripe calls will fail without it.")
  end
end
