require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:author) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    # expect(Question.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

end
