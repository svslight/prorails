class UsersController < ApplicationController
  before_action :set_user, except: [:email_confirmations] 
  skip_before_action :authenticate_user!, only: [:email_confirmations]
  # before_action :authenticate_user!, except: :email_confirmations

  def email_confirmations
    password = Devise.friendly_token[0, 20]
    user = User.new(email: user_params[:email], password: password, password_confirmation: password)
    user.save!
    user.send_confirmation_instructions
    user.authorizations.create(provider: session[:provider], uid: session[:uid])
    session[:provider] = nil
    session[:uid] = nil
    redirect_to root_path, notice: 'Check Your e-mailbox to complete registration'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    accessible = [:email]
    # accessible << [ :password, :password_confirmation] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

end
