class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :answer
  expose :question, -> { Question.find(params[:question_id]) }

  def create
    @exposed_answer = question.answers.new(answer_params)

    if answer.save
      redirect_to question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end
end
