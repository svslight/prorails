class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    
    # подключаем QuestionSerializer
    # render json: @questions.to_json(include: :answers)
    render json: @questions
  end
end
