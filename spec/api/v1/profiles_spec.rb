require 'rails_helper'

describe 'Profiles API', type: :request do

  let(:headers) {{ "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' }}

  describe 'GET /api/v1/profiles/me' do
    
    # Использование shared spec
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      # json(parse) - вызывается из spec/support/api_helpers.rb
      # as_json - преобразует в формат json но не в строку (для date)
      it 'returns all public files' do
        %w[id email admin created_at updated_at].each  do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private files' do
        %w[password encrypted_password].each do |attr|
          expect(json).not_to have_key(attr)
        end
      end
    end
  end
end
