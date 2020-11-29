class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]  
  before_action :set_question, only: [:show, :destroy, :update]
  before_action :load_subscription, only: %i[show update]
  
  # Передача данных в stream
  after_action :publish_question, only: [:create]

  expose :questions, -> { Question.all }
  expose :question, scope: -> { Question.with_attached_files }  
  expose :answer, -> { Answer.new }

  authorize_resource

  def new
    question.links.new
    question.reward = Reward.new
  end

  def show
    answer.links.new
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
    question.update(question_params)
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Your question was successfully deleted.'
  end

  private

  def load_subscription
    @subscription = question.subscriptions.find_by(user: current_user)
  end

  def question_params
    params.require(:question).permit(
      :title, 
      :body,
      files: [],
      links_attributes: %i[id name url _destroy],
      reward_attributes: %i[name image]
      )
  end

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast(
      'questions', question: render_question

      # ApplicationController.render(
      #   partial: 'questions/question',
      #   locals: { question: question, current_user: nil }
      # )      
    )
  end

  def render_question
    ApplicationController.renderer.instance_variable_set(
      :@env, {
        "HTTP_HOST"=>"localhost:3000", 
        "HTTPS"=>"off", 
        "REQUEST_METHOD"=>"GET", 
        "SCRIPT_NAME"=>"",   
        "warden" => warden
      }
    )
  
    ApplicationController.render(
      partial: 'questions/question',
      locals: { question: question, current_user: nil }
    )    
  end

  def set_question
    question = Question.find(params[:id])
    gon.question_id = question.id
    gon.user_id = current_user.id if current_user
  end
end
