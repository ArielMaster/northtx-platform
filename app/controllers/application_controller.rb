class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  before_action :set_cookie_consent

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  # Set cookies consent message to users.
  def set_cookie_consent
    @cookie_consent = cookies.signed[:cookie_consent] == "accepted"
  end
end
