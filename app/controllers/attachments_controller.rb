class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  expose :file, -> { ActiveStorage::Attachment.find(params[:id]) }

  
  def destroy
    authorize! :destroy, file
    file.purge

    # url = file.record_type == 'Answer' ? file.record.question : file.record
    # redirect_to question_path(url)
  end
end
  