class Reward < ApplicationRecord
  belongs_to :question, dependent: :destroy
  belongs_to :answer, optional: true

  has_one_attached :image

  validates :name, :image, presence: true
  
end
