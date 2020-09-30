require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do    
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'Get #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end    
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save a new question in the database' do    
        count = Question.count
        
        # чтобы не вручную передавать атрибуты, воспльзуемся фабрикой (FactoryBot)
        # у FactoryBot есть атрибут (attributes_for)- 
        # он возвращает в качестве хеша параметры из /spec/factories/questions.rb

        # post :create, params: { question: { title: '123', body: '123' } }                
        # post :create, params: { question: attributes_for(:question) } 
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        # expect(Question.count).to eq count + 1
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)  
      end
    end  

    # что происходит если пришли invalid атрибуты
    context 'with invalid attributes' do

      # нужно проверить что запрос POST create не меняет кол-во
      # и здест д.б. не валидные параметры, а attributes_for(:question) - вернет валидный параметр
      # поэтому используем фабрику questions.rb - там нужно найти невалидный question
      # и используем механизм trait и внутри которого можем добавить
      # метод нестандартной фабрики

      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      # повторно рендерится форма чтобы показать ошибки валидации
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new # проверяем что был отрендерин вид new
      end      
    end
  end
end
