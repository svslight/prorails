require 'rails_helper'
# require 'cancan/matchers'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    # создадим пустого usera, когда будет вызываться subject
    # в качестве аргумента будет передаваться (nil)
    let(:user) { nil }

    # передаем action и subject (ресурс над которым можем производить действие)
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    
    it { should_not be_able_to :manage, :all }    # указать что user делать не может
  end

  describe 'for admin' do    
    let(:user) { create :user, admin: true }     # создадим пользователя с флагом админ

    it { should be_able_to :manage, :all }    
  end

  describe 'for user' do    
    let(:user) { create :user }                                           # создаем обычного usera
    let(:question) { create(:question, author: user) }                   # создаем вопрос связанный с текущим userОм
    let(:answer) { create(:answer, question: question, author: user) }  # создаем ответ на вопрос связанный с текущим userОм

    let(:other_user) { create :user }                                            # создаем другого usera
    let(:other_question) { create :question, author: other_user }                # создаем вопрос связанный с другим userОм
    let(:other_answer) { create :answer, question: question, author: other_user }  # создаем ответ на вопрос связанный с другим userОм
    
    it { should_not be_able_to :manage, :all } # user не может управлять всем
    it { should be_able_to :read, :all }       # user может читать все

    # тесты на создание объектов залогиненного usera
    # чтобы тесты прошли нужно дать права в классе Ability
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    # проверка что user может обновлять свой вопрос и не может изменять чужой
    # чтобы тесты прошли нужно дать права в классе Ability на update для конкретной instanse переменной
    it { should be_able_to :update, question } 
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }   
  end
end
