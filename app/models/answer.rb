class Answer < ApplicationRecord
  include Voteable

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_one :reward
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { order best: :desc }

  def mark_best
    question.answers.update_all(best: false)
    
    transaction do
      update(best: !best)
      question.reward.update(answer: self) if question.reward.present?
    end
  end
end
