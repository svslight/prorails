require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:rewards) {create_list(:reward, 2, question: question)}

  describe 'GET #index' do

    before do
      login(user)
      get :index
    end

    it 'populates an array of all rewards' do
      expect(controller.rewards).to eq rewards
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
