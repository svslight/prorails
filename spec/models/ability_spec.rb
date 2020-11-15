require 'rails_helper'
# require 'cancan/matchers'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question, author: user) }
    let(:other_question) { create :question, author: other }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:other_answer) { create :answer, question: question, author: other }
    let(:link_question) { create :link, linkable: question }
    let(:other_link_question) { create :link, linkable: other_question }
    let(:link_answer) { create :link, linkable: answer }
    let(:other_link_answer) { create :link, linkable: other_answer }  

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Vote }
    it { should be_able_to :vote_up, Question }
    it { should be_able_to :vote_down, Question }
    it { should be_able_to :vote_up, Answer }
    it { should be_able_to :vote_down, Answer }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }
    it { should be_able_to :destroy, question, user: user }
    it { should_not be_able_to :destroy, other_question, user: user }
    it { should be_able_to :destroy, link_question }
    it { should_not be_able_to :destroy, other_link_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }
    it { should be_able_to :mark_best, answer }
    it { should_not be_able_to :mark_best, create(:answer, author: other, question: other_question) }
    it { should be_able_to :destroy, link_answer }
    it { should_not be_able_to :destroy, other_link_answer }
    it { should be_able_to :vote_up, other_answer }
    it { should be_able_to :vote_down, other_answer }
    it { should be_able_to :destroy, ActiveStorage::Attachment }
  end
end
