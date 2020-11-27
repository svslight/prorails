class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    SubscriptionService.new.send_notificatation(answer)
  end
end
