class CookieConsentController < ApplicationController
  skip_before_action :verify_authenticity_token

  def accept
    cookies.signed[:cookie_consent] = {
      value: "accepted",
      expires: 1.year.from_now,
      httponly: true
    }

    head :ok
  end
end
