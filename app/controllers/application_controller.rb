class ApplicationController < ActionController::Base

  #before_action :authenticate_user!, unless: :devise_controller?
  skip_before_action :authenticate_user!, raise: false

  before_action :gon_user, unless: :devise_controller?  
  
  # обработчик исключений: вызов стандартного сообщения 
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
