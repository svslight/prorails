class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  # expose :question, scope: -> { Question.with_attached_files }
  expose :question, -> { params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new }
  expose :answer, -> { Answer.new }

  def create
    @exposed_question = current_user.author_questions.new(question_params)

    if question.save
      redirect_to question_path(question), notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author?(question)
  end

  def destroy
    if current_user.author?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question was successfully deleted.'
    else
      redirect_to questions_path, notice: 'You have no rights to do this.'
    end
  end

  private
  
  # def load_question
  #   @question = Question.with_attached_files.find(params[:id])
  # end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
