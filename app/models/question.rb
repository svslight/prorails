class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'

  has_many :links, dependent: :destroy

  has_many_attached :files

  # макрос - модель question может принимать атрибуты для модели links
  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true
end
