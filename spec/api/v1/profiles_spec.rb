require 'rails_helper'

describe 'Profiles API', type: :request do

  let(:headers) {{ "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' }}

  describe 'GET /api/v1/profiles/me' do
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Successfulable'

      it_behaves_like 'API Publicfileable' do
        let(:attributes) {  %w[id email admin created_at updated_at] }
        let(:json_object) { json['user'] }
        let(:object) { me }
      end

      it_behaves_like 'API Privatefileable' do
        let(:attributes) { %w[password encrypted_password] }
        let(:json_object) { json }
      end
    end
  end

  describe 'GET /api/v1/profiles' do    

    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/profiles' }
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:me) { create(:user) }
      let(:user) { users.last }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:user_response)  { json['users'].last }
      
      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }
      
      it_behaves_like 'API Successfulable'

      it_behaves_like 'API Publicfileable' do
        let(:attributes) {  %w[id email admin created_at updated_at] }
        let(:json_object) { user_response }
        let(:object) { user }
      end

      it_behaves_like 'API Privatefileable' do
        let(:attributes) { %w[password encrypted_password] }
        let(:json_object) { json }
      end
      
      it 'returns list of users' do
        expect(json['users'].size).to eq 3
      end
    end
  end
end
