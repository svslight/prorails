require 'rails_helper'

RSpec.describe AnswersController, type: :controller do  
  let(:user_author) { create(:user) }
  let(:question) { create(:question, author: user_author) }

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

    let!(:answer) { create(:answer, question: question, author: user_author ) }

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
    let!(:question) { create(:question, author: user_author) }
    let!(:answer) { create(:answer, question: question, author: user_author) }

    let!(:other_user) { create(:user) }
    let!(:other_answer) { create(:answer, question: question, author: other_user) }

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

      it 'renders destroy view' do
        delete :destroy, params: { id: other_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

end
