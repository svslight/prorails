class ConfirmationsController < Devise::ConfirmationsController

  # def show
  #   user = User.find_by(confirmation_token: params[:confirmation_token])
  #   if user
  #     user.update!(account_confirmed: true) 
  #     flash[:notice] = 'Your email was confirmed. Now u can sign in.'
  #   else
  #     flash[:notice] = 'OOups.Smthng went wrong!'
  #   end
  #   redirect_to root_path
  # end
end
