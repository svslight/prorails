class UserMailer < ActionMailer::Base
  default from: 'svslight@yandex.ru'

  def registration_confirmation(user)
    @user = user
    mail to: user.email, subject: 'Please confirm your registration!!!'
  end
end
