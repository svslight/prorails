class LinksController < ApplicationController
  before_action :authenticate_user!

  expose :link, -> { Link.find(params[:id]) }

  def destroy
    link.destroy if current_user.author?(link.linkable)

    url = link.linkable_type == 'Answer' ? link.linkable.question : link.linkable
    redirect_to question_path(url)
  end
end
