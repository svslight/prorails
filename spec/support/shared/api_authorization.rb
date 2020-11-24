shared_examples_for 'API Authorizable' do

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
  end
end

shared_examples_for 'API Privatefileable' do
  it 'does not return private files' do
    attributes.each do |attr|
      expect(json_object).not_to have_key(attr)
    end
  end
end

shared_examples_for 'API Objectable' do
  it 'return list of object' do
    expect(object.size).to eq count
  end
end
