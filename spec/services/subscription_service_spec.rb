require 'rails_helper'

RSpec.describe SubscriptionService, type: :services do
  let(:question) {create(:question)}
  let(:subscriptions) { create_list(:subscription, 3, question: question) }
  let(:answer) {create(:answer, question: question)}

  it 'sends notification email to subscriptions' do
    question.subscriptions.each {|subscription| expect(SubscriptionMailer).to receive(:notification).with(subscription.user, answer).and_call_original}
    subject.send_notificatation(answer)
  end
end
