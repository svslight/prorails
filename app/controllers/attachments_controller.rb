class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  expose :attachment, -> { ActiveStorage::Attachment.find(params[:id]) }
  
  def destroy
    attachment.purge if current_user.author?(attachment.record)

    url = attachment.record_type == 'Answer' ? attachment.record.question : attachment.record
    redirect_to question_path(url)
  end
end
  