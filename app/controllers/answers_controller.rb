class AnswersController < ApplicationController
  before_action :authenticate_user!

  include Voted

  expose :answer
  expose :question, -> { Question.find(params[:question_id]) }

  def create
    @exposed_answer = question.answers.create(answer_params.merge(author_id: current_user.id))
  
    # Асинхронный HTML (AJAH) 
    # respond_to do |format|
    #   if answer.save
    #     format.html { render answer }
    #   else
    #     format.html do
    #       render partial: 'shared/errors', locals: { resource: answer },
    #                           status: :unprocessable_entity
    #     end
    #   end
    # end

    # Асинхронный JSON 
    # respond_to do |format|
    #   if answer.save
    #     format.json {render json: answer} 
    #   else      		 
    #     format.json do
    #       render json: answer.errors.full_messages, status: :unprocessable_entity
    #     end
    #   end
    # end
  end

  def update
    answer.update(answer_params) if current_user.author?(answer)
    @exposed_question = answer.question
  end

  def destroy
    answer.destroy if current_user.author?(answer)
  end

  def mark_best
    answer = Answer.find(params[:id])
    answer.mark_best if current_user.author?(answer.question)
    @exposed_question = answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(
      :body, 
      files: [], 
      links_attributes: [:id, :name, :url, :_destroy]
      )
  end
end
