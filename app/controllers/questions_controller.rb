class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action -> { question.links.build }, only: [:new, :create]
  before_action -> { answer.links.build }, only: [:show]

  expose :questions, -> { Question.all }
  expose :question, scope: -> { Question.with_attached_files }  
  expose :answer, -> { Answer.new }

  def new
    question.reward = Reward.new
  end

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

  def question_params
    params.require(:question).permit(
      :title, 
      :body,
      files: [],
      links_attributes: %i[id name url _destroy],
      reward_attributes: %i[name image]
      )
  end
end
