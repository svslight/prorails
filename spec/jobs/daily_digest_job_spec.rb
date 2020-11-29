require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  # нужно протестировать что вызывается метод send_digest Сервиса DailyDigestService
  let(:service) { double('DailyDigestService') }

  before do
    allow(DailyDigestService).to receive(:new).and_return(service)
  end

  it 'calls DailyDigestService#send_digest' do
    # проверяем что :service (созданый объект) получает вызов метода send_digest
    # и это происходит если у класса фоновой задачи DailyDigestJob вызываем метод perform_now
    expect(service).to receive(:send_digest)
    DailyDigestJob.perform_now
  end
end
