shared_examples_for 'API Authorizable' do
  # этот подход не гибкий т.к. для создания такая shared speca не пройдет
  # сделаем универсальный метод (do_request) в spec/support/api_helpers.rb
  # do_request(method-который будем исполь для запроса, path, options={} )
  # get меняем на do_request
  # в спеках добавить let(:method) { :get }
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'API Successfulable' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'API Publicfileable' do
  it 'returns all public files' do
    attributes.each do |attr|
      expect(json_object[attr]).to eq object.send(attr).as_json
    end
    # %w[id email admin created_at updated_at].each  do |attr|
    #   expect(json['user'][attr]).to eq me.send(attr).as_json
    # end
  end
end

shared_examples_for 'API Privatefileable' do
  it 'does not return private files' do
    attributes.each do |attr|
      expect(json_object).not_to have_key(attr)
    end
    # %w[password encrypted_password].each do |attr|
    #   expect(json).not_to have_key(attr)
    # end
  end
end
