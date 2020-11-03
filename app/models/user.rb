class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :authorizations, dependent: :destroy
  has_many :author_questions, foreign_key: 'author_id', class_name: 'Question'
  has_many :author_answers, foreign_key: 'author_id', class_name: 'Answer'
  has_many :rewards, through: :author_answers
  has_many :votes, dependent: :destroy
  has_many :comments  

  def author?(resource)
    id == resource.author_id
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end  

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end  
end
