# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Plan.create!(name: "Core", price_cents: 19900, interval: "month", features: "- 1 project\n- Basic analytics\n- Email support")
Plan.create!(name: "Growth", price_cents: 29900, interval: "month", features: "- 5 projects\n- Advanced analytics\n- Priority email support\n- Custom branding")
Plan.create!(name: "Professional", price_cents: 39900, interval: "month", features: "- Unlimited projects\n- Team collaboration\n- API access\n- Priority support")
Plan.create!(name: "Enterprise", price_cents: 79900, interval: "month", features: "- Unlimited everything\n- Dedicated account manager\n- SLA uptime guarantee\n- Custom integrations\n- Onboarding & training")
