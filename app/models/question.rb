class Question < ApplicationRecord
  include Commentable
  
  belongs_to :author, class_name: 'User'
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :voteable
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files
  
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :calculate_reputation  
  after_create :subscribe_author

  scope :last_day, -> { where('created_at >= ?', 2.day.ago) }

  def rating
    self.votes.sum(:value)
  end

  private

  def subscribe_author
    subscriptions.create(user: author)
  end

  # Вызов фоновой задачи ReputationJob
  def calculate_reputation
    ReputationJob.perform_later(self)
  end

end
