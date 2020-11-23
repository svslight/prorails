require 'rails_helper'
require Rails.root.join 'spec/models/concerns/commentable_spec'

RSpec.describe Question, type: :model do
  it { should belong_to(:author) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  # модель принимает вложенные атрибуты
  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  # тестируем сервис для вычисления репутации
  # делаем build - дистанциируем в памяти но не сохраняем в бд
  # для тестирования вызываем класс фоновой задачи и perform_later
  # perform_now - выполняет задачу синхронно
  # perform_later - добавляет задачу в очередь
  # и все это происходит когда сохраняем объект question.save!
  describe "reputation" do
    let(:question) { build(:question) }
    
    it 'calls ReputationJob#perform_later' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end  
end
