class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  # Включение коллекций
  has_many :answers
  has_many :comments
  has_many :links
  has_many :files

  # Включение отвельных ассоциаций
  belongs_to :author
  
  def short_title
    # Метод для вычисляемого атрибута (short_title) 
    object.title.truncate(7)
  end
end
