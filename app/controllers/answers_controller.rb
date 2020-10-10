class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :answer
  expose :question , -> { Question.find(params[:question_id]) }

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.author = current_user

    if answer.save
      redirect_to question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      redirect_to answer.question, notice: 'Your answer has been deleted.'
    else
      redirect_to answer.question, notice: 'You are not the author of the answer.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
