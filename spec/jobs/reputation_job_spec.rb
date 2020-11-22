require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  # Тест сводится к проверке нужных вызовов
  # для тестирования вызываем класс фоновой задачи и perform_now
  # perform_now - выполняет задачу синхронно
  # perform_later - добавляет задачу в очередь
  let(:question) { create(:question) }

  it 'calls Reputation#calculate' do
    expect(Reputation).to receive(:calculate).with(question)
    ReputationJob.perform_now(question)
  end
end
