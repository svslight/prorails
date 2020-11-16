# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user    
    
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Vote, Reward]
    can [:vote_up, :vote_down], [Question, Answer]
    can %i[update destroy], [Question, Answer], author_id: user.id
    can :mark_best, Answer, question: { author_id: user.id }
    can :destroy, Link, linkable: { author_id: user.id }
    can :read, Reward
 
    # can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    # can :destroy, ActiveStorage::Attachment do |file|
    #   user.author?(file.record)
    # end

    can [:vote_up, :vote_down], [Question, Answer] do |voteable|
      !user.author?(voteable) && !voteable.votes.exists?(user_id: user.id)
    end
  end
end
