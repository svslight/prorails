require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{ "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' }}

  describe 'GET /api/v1/questions' do
    #  делаем проверку что запрос защищен Doorkeeper
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }

      # Тестирование возврата списка ответов на первом элементе
      let(:question) { (questions.first)}
      
      # (json) parse - вызывается из spec/support/api_helpers.rb
      # из ответа берем нужный элемент, а не весь первый объект
      let(:question_response) { json['questions'].first }

      # Объявляем создание ответов перед before чтобы ответы возвращались с вопросами
      let!(:answers) {create_list(:answer, 3, question: question)}

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return list of qiestions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public files' do
        %w[id title body created_at updated_at].each  do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      # проверим что author_id возвращает author_id
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

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end
