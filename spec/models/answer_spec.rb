require 'rails_helper'

RSpec.describe Answer, type: :model do
  it{ should validate_presence_of :body}
  it{ should validate_presence_of :correct}
end