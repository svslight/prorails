class SubscriptionService

  def send_notificatation(answer)
    answer.question.subscriptions.includes(:user).find_each(batch_size: 500)  do |subscription|
      SubscriptionMailer.notification(subscription.user, answer).deliver_later
    end
  end
end
