require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{ "CONTENT_TYPE" => "application/json",
    "ACCEPT" => 'application/json' }}

  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }

  describe 'GET index /api/v1/questions' do

    let(:api_path) {  '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { (questions.first)}   
      let(:question_response) { json['questions'].first }
      let!(:answers) {create_list(:answer, 3, question: question)}

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Successfulable'

      it_behaves_like 'API Objectable' do
        let(:object) { json['questions'] }
        let(:count) { 2 }
      end

      it_behaves_like 'API Publicfileable' do
        let(:attributes) { %w[id title body created_at updated_at] }
        let(:json_object) { question_response }
        let(:object) { question }
      end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do        
        let(:answer) { answers.first }        
        let(:answer_response) { question_response['answers'].first }
      
        it_behaves_like 'API Objectable' do
          let(:object) { question_response['answers'] }
          let(:count) { 3 }
        end

        it_behaves_like 'API Publicfileable' do
          let(:attributes) { %w[id body created_at updated_at] }
          let(:json_object) { answer_response }
          let(:object) { answer }
        end
      end
    end
  end

  describe 'GET show /api/v1/questions/id' do
    let!(:question) { create(:question, :with_files) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:question_response) { json['question'] }

    let!(:answers) {create_list(:answer, 3, question: question)}
    let!(:comments) { create_list(:comment, 3, commentable: question) }
    let!(:links) { create_list(:link, 3, linkable: question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Successfulable'

      it_behaves_like 'API Publicfileable' do
        let(:attributes) { %w[id title body created_at updated_at] }
        let(:json_object) { question_response }
        let(:object) { question }
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of comments' do
          expect(comment_response['id']).to eq question.comments.first.id
        end

        it_behaves_like 'API Publicfileable' do
          let(:attributes) { %w[id body user_id created_at updated_at] }
          let(:json_object) { comment_response }
          let(:object) { comment }
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { question_response['links'].first }

        it 'returns list of links' do
          expect(link_response['id']).to eq question.links.first.id
        end

        it_behaves_like 'API Publicfileable' do
          let(:attributes) { %w[id name url created_at updated_at] }
          let(:json_object) { link_response }
          let(:object) { link }
        end
      end

      describe 'files' do
        let(:file) { question.files.first }
        let(:file_response) { question_response['files'].first }

        it_behaves_like 'API Objectable' do
          let(:object) { question_response['files'] }
          let(:count) { question.files.count }
        end

        it 'contains files url' do
          expect(json['question']['files'].first['id']).to eq question.files.first.id
        end
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'] }

        it_behaves_like 'API Objectable' do
          let(:object) { answer_response }
          let(:count) { question.answers.count }
        end

        it_behaves_like 'API Publicfileable' do
          let(:attributes) { %w[id body best author_id created_at updated_at] }
          let(:json_object) { answer_response.first }
          let(:object) { answer }
        end
      end
    end
  end

  describe 'CREATE /api/v1/questions' do
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do

      before {post api_path, params: {access_token: access_token.token,  question: attributes_for(:question) }, headers: headers }

      it_behaves_like 'API Successfulable'              

      it_behaves_like 'API Objectable' do
        let(:object) { json }
        let(:count) { 1 }
      end
    end
  end

  describe 'PACH UPDATE /api/v1/questions/id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      before { patch api_path, params: { access_token: access_token.token, question: { title: 'Changed Title' } }, headers: headers }

      it_behaves_like 'API Successfulable'

      it 'Update question' do
        question.reload
        expect(question.title).to eq 'Changed Title'
      end
    end
  end

  describe 'DESTROY /api/v1/questions/id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }    
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      before { delete api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Successfulable'

      it 'return empty json' do
        expect(json).to be_empty
      end
    end
  end
end
