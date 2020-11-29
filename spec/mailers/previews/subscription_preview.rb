# Preview all emails at http://localhost:3000/rails/mailers/subscription
class SubscriptionPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subscription/notification
  def notification
    SubscriptionMailer.notification
  end

end
