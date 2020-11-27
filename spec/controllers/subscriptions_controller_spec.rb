require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }  

  describe 'POST #create' do

    context 'Unauthenticated user' do
      before { sign_out(user) }
      let(:subscribe) { post :create, params: { question_id: question.id, format: :js } }

      it 'does not save the subscription' do
        expect { subscribe }.to_not change(Subscription, :count)
      end
    end

    context 'Authenticated user' do
      before { sign_in(user) }      
      let(:subscribe) { post :create, params: { question_id: question.id, format: :js } }    

      it 'saves a new subscription to DB' do
        expect { subscribe }.to change(Subscription, :count).by(1)
      end

      it 'saves a new subscription to the logged user' do
        expect { subscribe }.to change(user.subscriptions, :count).by(1)
      end

      it 'saves a new subscription to the question' do
        expect { subscribe }.to change(question.subscriptions, :count).by(1)
      end

      it_behaves_like 'API Successfulable' do
        before { subscribe }
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create :subscription, question: question, user: user }
    let(:other_user) { create(:user) }

    context 'Author tries' do
      before { sign_in(user) }

      it 'deletes his subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to change(question.subscriptions, :count).by(-1)
      end
    end

    context 'Not author tries' do
      before { sign_in(other_user) }

      it 'delete not his subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to_not change(question.subscriptions, :count)
      end
    end  
  end
end
