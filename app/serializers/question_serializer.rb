class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  has_many :answers
  has_many :comments
  has_many :links
  has_many :files

  belongs_to :author
  
  def short_title
    object.title.truncate(7)
  end

  def files
    object.files.map do |file|
      { id: file.id, url: rails_blob_path(file, only_path: true) }
    end
  end
end
