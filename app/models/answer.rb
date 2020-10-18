class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { order best: :desc }

  def mark_best
    other_best_answer = question.answers.update_all(best: false)

    transaction do
      update(best: !best)
    end
  end
end
