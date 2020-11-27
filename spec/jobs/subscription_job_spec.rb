require 'rails_helper'

RSpec.describe SubscriptionJob, type: :job do
  let(:service) { double('Services::SubscriptionService') }
  let(:answer) {build(:answer)}

  before do
    allow(SubscriptionService).to receive(:new).and_return(service)
  end

  it 'calls Service::SubscriptionService#send_notificatation' do
    expect(service).to receive(:send_notificatation)
    SubscriptionJob.perform_now(answer)
  end
end
