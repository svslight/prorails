class Question < ApplicationRecord
  include Commentable
  
  belongs_to :author, class_name: 'User'
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :voteable
  # has_many :comments, dependent: :destroy, as: :commentable

  has_many_attached :files
  
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  # указывем вызов (сервис для вычисления репутации)
  # через метод after_create
  after_create :calculate_reputation

  def rating
    self.votes.sum(:value)
  end

  private

  # Вызов фоновой задачи ReputationJob
  def calculate_reputation
    ReputationJob.perform_later(self)
  end

end
