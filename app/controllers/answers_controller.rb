class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :answer, -> { params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new }
  expose :question, -> { Question.find(params[:question_id]) }

  def create
    @exposed_answer = question.answers.create(answer_params.merge(author_id: current_user.id))
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

  # def load_answer
  #   @answer = Answer.with_attached_files.find(params[:id])
  # end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
