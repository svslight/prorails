class Link < ApplicationRecord

  URL_FORMAT = /\A(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?\z/ix

  belongs_to :linkable, polymorphic: true
  
  validates :name, presence: true
  validates :url, presence: true, format: { with: URL_FORMAT, message: 'URL has an invalid format!!!' }

  def gist?
    url =~ /gist.github.com/
  end

  def gist_content
    Octokit::Client.new.gist(url.split('/').last).files.first[1].content if gist?
  end  
end
