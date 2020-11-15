class RewardsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  expose :rewards, -> { Reward.all }
  expose :user_rewards, -> { current_user.rewards }

end
