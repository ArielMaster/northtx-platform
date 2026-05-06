class Receipt < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  # attributes:
  # user_id:integer
  # plan_id:integer
  # amount_cents:integer
  # currency:string
  # stripe_session_id:string
end
