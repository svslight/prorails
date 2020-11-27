class SubscriptionMailer < ApplicationMailer

  def notification(subscriber, answer)
    @answer = answer
    @question = answer.question
    @subscriber = subscriber

    mail to: subscriber.email
  end
end
