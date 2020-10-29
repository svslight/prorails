require 'active_support/concern'

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: %i[vote_up vote_down]
  end

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  def vote(value)
    return anauthorized! if current_user.author?(@voteable)

    if @voteable.votes.where(user: current_user).exists?
      @voteable.votes.find_by(user: current_user).update_attribute(:value, value)
    else
      @voteable.votes.create(user: current_user, value: value)
    end

    render json: { rating: @voteable.votes.sum(:value), id: @voteable.id }
  end

  def anauthorized!
    render json: { error: "You can not vote for your #{model_klass.to_s.downcase}" }, status: 403
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end
end
