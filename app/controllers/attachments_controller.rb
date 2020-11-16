class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  expose :attachment, -> { ActiveStorage::Attachment.find(params[:id]) }

  authorize_resource
  
  def destroy
    attachment.purge

    url = attachment.record_type == 'Answer' ? attachment.record.question : attachment.record
    redirect_to question_path(url)
  end
end
  