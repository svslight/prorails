require 'rails_helper'
require Rails.root.join 'spec/models/concerns/voteable_spec'

RSpec.describe Question, type: :model do
  it_behaves_like 'voteable' do
    let(:user) { create(:user) }
    let(:resource) { create(:question, author: user) }
  end

  it { should belong_to(:author) }
  it { should have_many(:answers).dependent(:destroy) }

  it{ should have_many(:links).dependent(:destroy)}

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  # модель принимает вложенные атрибуты
  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  # it "has the module Voteable" do
  #   expect(described_class.include?(Voteable)).to eq true
  # end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
