require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user_author) { create(:user) }
  let(:question) { create(:question, author: user_author) }

  describe 'GET #new' do
    before { login(user_author) }
    before { get :new }
    
    it 'assigns to new questions new link' do
      # get :new
      expect(assigns(:exposed_question).links.first).to be_a_new(Link)
    end

    it 'assigns a new Reward to question' do
      expect(assigns(:exposed_question).reward).to be_a_new(Reward)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns new link for answer' do
      expect(assigns(:exposed_answer).links.first).to be_a_new(Link)
    end
  end

  describe 'POST #create' do
    before { login(user_author) }

    context 'with valid attributes' do
      it 'save a new question in the database' do    
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end  

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new 
      end      
    end
  end

  describe 'PATCH #update' do
    before { login(user_author) }

    context 'with valid attributes' do      
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:exposed_question)).to eq question
      end
           
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body' 
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload
        
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user_author) }
    let!(:question) { create(:question, author: user_author) }
 
    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
