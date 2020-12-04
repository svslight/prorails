require 'rails_helper'

RSpec.describe 'SearchService class' do
  describe '#search_results' do
    let!(:search_text) { 'some text' }

    %w[Questions Answers Comments Users].each do |search_object|
      it "returns results for #{search_object}" do
        expect(search_object.classify.constantize).to receive(:search).with(search_text)
        SearchService.search_results(search_text, search_object)
      end
    end

    it 'returns results for All' do
      expect(ThinkingSphinx).to receive(:search).with(search_text)
      SearchService.search_results(search_text, 'All')
    end
  end
end
