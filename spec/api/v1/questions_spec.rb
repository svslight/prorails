require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{ "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' }}

  describe 'GET INDEX /api/v1/questions' do

    let(:api_path) {  '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }

      let(:question) { (questions.first)}   
      let(:question_response) { json['questions'].first }
      let!(:answers) {create_list(:answer, 3, question: question)}

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Successfulable'

      it 'return list of qiestions' do
        expect(json['questions'].size).to eq 2
      end

      # returns all public files question
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

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do        
        let(:answer) { answers.first }        
        let(:answer_response) { question_response['answers'].first }  # Берем внутри объекта answers первый элемент
      
        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3   # Проверяем что возвращается список ответов
        end

        # returns all public fields answer
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

  describe 'GET SHOW /api/v1/questions/id' do
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

      # returns all public files question
      # it_behaves_like 'API Publicfileable' do
      #   let(:attributes) { %w[id title body created_at updated_at] }
      #   let(:json_object) { question_response }
      #   let(:object) { question }
      # end
      it 'returns all public files' do
        %w[id title body created_at updated_at].each  do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
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

        # returns all public fields answer
        # it_behaves_like 'API Publicfileable' do
        #   let(:attributes) { %w[id body created_at updated_at] }
        #   let(:json_object) { answer_response }
        #   let(:object) { answer }
        # end
        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { question_response['links'].first }

        it 'returns list of links' do
          expect(link_response['id']).to eq question.links.first.id
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json         
          end
        end
      end

      describe 'files' do
        let(:file) { question.files.first }
        let(:file_response) { question_response['files'].first }

        it 'returns urls of files' do
          expect(question_response['files'].size).to eq question.files.count
        end

        # it 'returns url file' do
        #   expect(json['question']['files'].first['id']).to eq question.files.first.id
        # end
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'] }

        it 'returns list of answers' do
          expect(answer_response.size).to eq question.answers.count
        end

        it 'returns all public fields' do
          %w[id body best author_id created_at updated_at].each do |attr|
            expect(answer_response.first[attr]).to eq answer.send(attr).as_json
          end
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
      let(:user) { create(:user) }
      let(:access_token) {create(:access_token)}
      let(:question) { create(:question) }

      before {post api_path, params: { question: {user_id: user.id, title: 'test Title', body: 'test Body' }, 
                                        access_token: access_token.token }, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns question' do
        expect(json.size).to eq 1
      end

      it 'contains title and body of question' do
        expect(json['question']['title']).to eq "test Title"
        expect(json['question']['body']).to eq "test Body"
      end
    end
  end

  describe 'PACH UPDATE /api/v1/questions/id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:access_token) {create(:access_token)}
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      before { patch api_path, params: { access_token: access_token.token, question: { title: 'Changed Title' } }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'Update question' do
        question.reload
        expect(question.title).to eq 'Changed Title'
      end
    end
  end

  describe 'DESTROY /api/v1/questions/id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }    
    let!(:question) { create(:question) }
    let(:access_token) {create(:access_token)}
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      before { delete api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return empty json' do
        # expect { delete api_path, params: { access_token: access_token.token } }.to change(Question, :count).by(-1)
        delete api_path, params: { access_token: access_token.token }, headers: headers
        expect(json).to be_empty
      end
    end
  end
end
