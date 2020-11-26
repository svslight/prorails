class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  # метод digest формирует письмо
  def digest(user)
    @greeting = "Hi"
    @questions = Question.last_day

    mail to: user.email
  end
end
