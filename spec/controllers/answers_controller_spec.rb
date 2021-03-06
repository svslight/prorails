require 'rails_helper'
require Rails.root.join 'spec/controllers/concerns/voted_spec'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, author: user) }
    let(:resource) { create(:answer, question: question, author: user) }
  end

  let(:user_author) { create(:user) }
  let(:question) { create(:question, author: user_author) }
  let!(:answer) { create(:answer, question: question, author: user_author ) }

  let!(:other_user) { create(:user) }
  let!(:other_answer) { create(:answer, question: question, author: other_user) }

  describe 'POST #create' do
    before { login(user_author) }

    context 'with valid attributes' do
      it 'save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'redirects create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js 
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do  
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js 
        expect(response).to render_template :create
      end
    end
  end
  
  describe 'PATCH #update' do
    before { login(user_author) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end
  
  describe 'DELETE #destroy' do
    before { login(user_author) }

    context 'Author' do
      it 'tries delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author' do
      it 'tries delete the answer' do
        expect { delete :destroy, params: { id: other_answer }, format: :js }.not_to change(Answer, :count)
      end

      # it 'renders destroy view' do
      #   delete :destroy, params: { id: other_answer }, format: :js
      #   expect(response).to render_template :destroy
      # end
    end
  end

  describe 'POST #best_answer' do 
    
    context 'Owner question' do
      before { login(user_author) }   
      before { post :mark_best, params: { id: answer }, format: :js }

      it 'trying choose best answer' do
        expect { answer.reload }.to change { answer.best }.from(false).to(true)
      end

      it 'renders best template' do
        expect(response).to render_template :mark_best
      end
    end

    # context 'Not owner question is trying choose answer as best' do
    #   before { login(other_user) }
    #   before { post :mark_best, params: { id: answer }, format: :js }

    #   it 'trying choose best answer' do
    #     expect { answer.reload }.not_to change(answer, :best)
    #   end

    #   it 'renders best template' do
    #     expect(response).to render_template :mark_best
    #   end
    # end
  end
end
