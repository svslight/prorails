class Answer < ApplicationRecord
  include Commentable
  
  belongs_to :question, touch: true
  belongs_to :author, class_name: 'User'
  has_one :reward
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :voteable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { order best: :desc }

  after_create :notify_subscribers

  def mark_best
    question.answers.update_all(best: false)
    
    transaction do
      update(best: !best)
      question.reward.update(answer: self) if question.reward.present?
    end
  end

  def rating
    self.votes.sum(:value)
  end

  private

  def notify_subscribers
    SubscriptionJob.perform_later(self)
  end
end
