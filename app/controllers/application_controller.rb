class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :gon_user, unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
