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
