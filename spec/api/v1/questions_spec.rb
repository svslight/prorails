require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{ "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' }}

  describe 'GET /api/v1/questions' do
    #  делаем проверку что наш запрос защищен Doorkeeper
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

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        # expect(response).to be_successful
        expect(response.status).to eq 200
      end

      it 'return list of qiestions' do
        expect(json.size).to eg 2
      end

      it 'returns all public files' do
        # json = JSON.parse(response.body)
        %w[id title body user_id created_at updated_at].each  do |attr|
          expect(json.first[attr]).to eq questions.first.send(attr).as_json
        end
      end

    end
  end

end
