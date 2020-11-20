require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{ "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' }}

  describe 'GET /api/v1/questions' do

    let(:api_path) {  '/api/v1/questions' }

    # Использование shared spec
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }

      let(:question) { (questions.first)}
      
      # (json) parse - вызывается из spec/support/api_helpers.rb
      let(:question_response) { json['questions'].first }

      # Объявляем создание ответов перед before чтобы ответы возвращались с вопросами
      let!(:answers) {create_list(:answer, 3, question: question)}

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Successfulable'

      it 'return list of qiestions' do
        expect(json['questions'].size).to eq 2
      end

      it_behaves_like 'API Publicfileable' do
        let(:attributes) { %w[id title body created_at updated_at] }
        let(:json_object) { question_response }
        let(:object) { question }
      end
      # it 'returns all public files' do
      #   %w[id title body created_at updated_at].each  do |attr|
      #     expect(question_response[attr]).to eq question.send(attr).as_json
      #   end
      # end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      # Вычисляемый атрибут (short_title) в QuestionSerializer
      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      # Вложенный объект - проверяет что возвращается список ответов (массив и поля)
      describe 'answers' do
        # проверяем на конкретном ответе
        let(:answer) { answers.first }

        # Берем внутри объекта answers первый элемент
        let(:answer_response) { question_response['answers'].first }

        # Проверяем что возвращается список ответов
        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it_behaves_like 'API Publicfileable' do
          let(:attributes) { %w[id body created_at updated_at] }
          let(:json_object) { answer_response }
          let(:object) { answer }
        end
        # it 'returns all public fields' do
        #   %w[id body created_at updated_at].each do |attr|
        #     expect(answer_response[attr]).to eq answer.send(attr).as_json
        #   end
        # end
      end
    end
  end
end
