class AnswersController < ApplicationController
  before_action :authenticate_user!

  include Voted
  include AnswersHelper

  expose :answers, -> { Answer.all }
  expose :answer, -> { params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new }
  expose :question, -> { Question.find(params[:question_id]) }

  authorize_resource

  after_action :publish_answer, only: [:create]

  def create
    @exposed_answer = question.answers.create(answer_params.merge(author_id: current_user.id))
  end

  def update
    answer.update(answer_params)
    @exposed_question = answer.question
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
  end

  def mark_best
    answer = Answer.find(params[:id])
    answer.mark_best
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

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast(
      "answers_question_#{question.id}",
      answer: answer,
      files: cable_files(answer),
      links: cable_links(answer)
    )
  end
end
