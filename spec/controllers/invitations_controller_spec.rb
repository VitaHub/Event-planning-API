require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do

  describe "POST #create" do
    let(:event) { create(:event) }

    let(:valid_attributes) do
      FactoryGirl.build(:invitation, event: event).attributes
    end

    it "returns http success" do
      post :create, params: { event_id: event.id, invitation: valid_attributes}
      expect(response).to have_http_status(:success)
    end

    context "with valid params" do
      it "creates a new Invitation" do
        expect {
          post :create, params: {event_id: event.id, invitation: valid_attributes} #, session: valid_session
        }.to change(Invitation, :count).by(1)
      end

      it "assigns a newly created invitation as @invitation" do
        post :create, params: {event_id: event.id, invitation: valid_attributes} #, session: valid_session
        expect(assigns(:invitation)).to be_a(Invitation)
        expect(assigns(:invitation)).to be_persisted
      end
    end 

    it "does not duplicate an existing Invitation" do
      post :create, params: {event_id: event.id, invitation: valid_attributes}
      expect {
        post :create, params: {event_id: event.id, invitation: valid_attributes} #, session: valid_session
      }.to change(Invitation, :count).by(0)
    end
  end

end