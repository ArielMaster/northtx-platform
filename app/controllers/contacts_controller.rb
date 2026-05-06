class ContactsController < ApplicationController
  # invisible_captcha only: [ :create, :new ]
  def index
    @contacts = Contact.all
  end
  def new
    @contact = Contact.new
  end
  # GET /contact/1 or /contact/1.json
  def show
    @contact = Contact.find(params[:id])
  end



  def create
    ip = request.remote_ip
    today_count = Contact.where(ip_address: ip, created_at: Time.zone.today.all_day).count

    if today_count >= 5
      flash[:alert] = "You have reached the maximum number of requests for today. Please try again tomorrow."
      redirect_to request.referer || root_path and return
    end

    @contact = Contact.new(contact_params)
    @contact.ip_address = ip

    if @contact.save
      redirect_to pages_blog_path, notice: "Your message was sent successfully!"
    else
      flash.now[:alert] = "Something went wrong. Please check the form and try again."
      render :new
    end
  end

  def correct_admin
    @contact = current_admin.contact.find_by(id: params[:id])
    redirect_to contact_path, notice: "Not Authorized to Edit this Contact" if @contact.nil?
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :last_name, :phone, :email, :subject, :message)
        .transform_values { |value| ActionController::Base.helpers.sanitize(value.strip) }
  end
end
