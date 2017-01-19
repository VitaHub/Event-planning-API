require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe "GET #index" do
    let(:event) { create(:event) }

    it "returns http success" do
      get :index, params: { event_id: event.id }
      expect(response).to have_http_status(:success)
    end
  end

end
