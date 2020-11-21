require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
    "ACCEPT" => 'application/json' } }

  let(:question) { create(:question) }
  let(:access_token) { create(:access_token) }

  describe 'GET index /api/v1/questions/:id/answers' do    
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let!(:answers) {create_list(:answer, 3, question: question)}
    let(:answer_response) { json['answers'].first }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Successfulable'

      it_behaves_like 'API Objectable' do
        let(:object) { json['answers'] }
        let(:count) { 3 }
      end

      it_behaves_like 'API Publicfileable' do
        let(:attributes) { %w[id body author_id question_id best created_at updated_at] }
        let(:json_object) { answer_response }
        let(:object) { answers.first }
      end
    end
  end

  describe 'GET show /api/v1/answers/:id' do
    let!(:answer) { create(:answer, :with_files, question: question) }
    let(:answer_response) { json['answer'] }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:link) { create(:link, linkable: answer) }      

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it_behaves_like 'API Successfulable'

      it_behaves_like 'API Objectable' do
        let(:object) { json }
        let(:count) { 1 }
      end

      it_behaves_like 'API Publicfileable' do
        let(:attributes) { %w[id body author_id created_at updated_at] }
        let(:json_object) { answer_response }
        let(:object) { answer }
      end

      it 'contains comments object' do
        expect(json['answer']['comments'].first['id']).to eq answer.comments.first.id
      end

      it 'contains links url' do
        expect(json['answer']['links'].first['id']).to eq answer.links.first.id
      end

      it 'contains files url' do
        expect(json['answer']['files'].first['id']).to eq answer.files.first.id
      end
    end
  end

  describe 'POST create /api/v1/questions/:id/answers/' do
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do

      before {post api_path, params: {access_token: access_token.token,  answer: attributes_for(:answer) }, headers: headers }

      it_behaves_like 'API Successfulable'

      it_behaves_like 'API Objectable' do
        let(:object) { json }
        let(:count) { 1 }
      end
    end
  end

  describe 'PATCH update /api/v1/answers/:id' do
    let(:headers) { { "ACCEPT" => 'application/json' } } 
    let!(:answer) { create(:answer, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do

      before { patch api_path, params: { access_token: access_token.token, answer: { body: 'Changed Body' }}}

      it_behaves_like 'API Successfulable'

      it 'returns changed answer' do
        answer.reload
        expect(answer.body).to eq 'Changed Body'
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let!(:answer) { create(:answer, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do

      before {delete api_path, params: {access_token: access_token.token}}

      it_behaves_like 'API Successfulable'

      it 'check answer after destroy' do
        expect(json).to be_empty
      end
    end
  end
end
