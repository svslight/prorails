class Api::V1::AnswersController < Api::V1::BaseController
  
  expose :answers, -> { question.answers } 
  expose :answer
  expose :question, -> { Question.find(params[:question_id]) }

  authorize_resource

  def index
    render json: answers
  end

  def show
    render json: answer
  end

  def create
    render json: question.answers.create(answer_params.merge(author_id: current_resource_owner))
  end

  def update
    render json: answer.update(answer_params)
  end

  def destroy
    render json:  {}, status: :ok if answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
