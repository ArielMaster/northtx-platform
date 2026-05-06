# app/mailers/receipt_mailer.rb
class ReceiptMailer < ApplicationMailer
  def send_receipt
    @receipt = params[:receipt]
    @user    = @receipt.user
    @plan    = @receipt.plan

    mail(
      to: @user.email,
      subject: "Your receipt for #{@plan.name}"
    )
  end
end
