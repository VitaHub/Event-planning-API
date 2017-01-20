require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:organizer) { create(:user) }
  let(:auth_headers) { organizer.create_new_auth_token }
  let(:event) { create(:event, organizer: organizer) }

  let(:valid_attributes) {
    FactoryGirl.build(:attachment, event: event).attributes
  }

  let(:invalid_attributes) {
    FactoryGirl.build(:attachment).attributes
  }

  describe "GET #index" do
    it "returns http success" do
      get :index, params: { event_id: event.id }.merge(auth_headers)
      expect(response).to have_http_status(:success)
    end
  end
end
