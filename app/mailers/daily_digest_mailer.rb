class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  # метод digest будет формирует и отсылает письмо
  # нужно указывать адрес конкретного usera  #{user.name}
  def digest(user)
    @greeting = "Hi #{user.name}"
    @questions = Question.last_day

    mail to: user.email, subject: 'Daily digest'
  end
end
