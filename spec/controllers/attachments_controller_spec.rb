require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user_author) { create(:user) }
    let(:question) { create(:question, :with_files, author: user_author) }

    let(:other_user) { create(:user) }
    let(:other_question) { create(:question, :with_files, author: user_author) }

    before { login user_author }

    context 'Authenticated user' do

      it 'delete his attached file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files,	:count).by(-1)
      end

      it 'deletes not his attached file' do
        expect { delete :destroy, params: { id: other_question.files.first }, format: :js }.to_not change(question.files, :count)
      end
    end
  end
end
