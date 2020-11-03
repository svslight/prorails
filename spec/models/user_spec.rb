require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:author_questions) }
  it { should have_many(:author_answers) }
  it { should have_many(:rewards) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:authorizations).dependent(:destroy) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    # double - создает фэйковый объект, в качестве аргумента принимает строку с любым именем
    let(:service) { double('FindForOauth') }

    # тест должен вызывать FindForOauth
    # проверить что вызывается конструктор этого класса с определенными аргументами
    # и созанный объект получает вызов метода call
    it 'call FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe 'User' do
    let(:author) { create(:user) }
    let(:author_questions) { create(:question, author: author) }
    let(:author_answers) { create(:answer, question: author_questions, author: author) }
  
    let(:other_author) { create(:user) }
    let(:other_question) { create(:question, author: other_author) }
    let(:other_answer) { create(:answer, question: other_question, author: other_author) }
  
    it 'User is author of question' do
      expect(author).to be_author(author_questions)
    end
  
    it 'User is not author of question' do
      expect(author).not_to be_author(other_question)
    end
  
    it 'User is author of answer' do
      expect(author).to be_author(author_answers)
    end
  
    it 'User is not author of answer' do
      expect(author).not_to be_author(other_answer)
    end
  end

end
