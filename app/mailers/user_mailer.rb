# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def set_password_instructions
    @user = params[:user]
    @token = @user.signed_id(purpose: :set_password, expires_in: 2.hours)

    mail(
      to: @user.email,
      subject: "Set up your account password"
    )
  end
end
