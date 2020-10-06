require 'rails_helper'

RSpec.describe AnswersController, type: :controller do  
  let(:user_author) { create(:user) }
  let(:question) { create(:question, author: user_author) }

  describe 'POST #create' do

    context 'with valid attributes' do
      before { login(user_author) }     

      it 'save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'redirects create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js 
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user_author) }

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js 
        expect(response).to render_template :create
      end
    end
  end
  
end
