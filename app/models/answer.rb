class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  scope :sort_by_best, -> { order best: :desc }

  def mark_best
    other_best_answer = question.answers.where(best: true).first
    transaction do
      other_best_answer&.update!(best: false)
      update!(best: !best)
    end
  end
end
