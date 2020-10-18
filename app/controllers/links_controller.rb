class LinksController < ApplicationController
  before_action :authenticate_user!

  expose :links, -> { Link.find(params[:id]) }

  def destroy
    links.destroy if current_user.author?(links.linkable)

    url = links.linkable_type == 'Answer' ? links.linkable.question : links.linkable
    redirect_to question_path(url)
  end
end
