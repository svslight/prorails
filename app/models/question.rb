class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'

  # has_one_attached :file
  has_many_attached :files

  validates :title, :body, presence: true
end
