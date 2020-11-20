class QuestionSerializer < ActiveModel::Serializer

  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  # Включение коллекции ответов
  has_many :answers

  # Включение отвельных ассоциаций
  belongs_to :author
  
  def short_title
    # Метод для вычисляемого атрибута (short_title) 
    object.title.truncate(7)
  end
end
