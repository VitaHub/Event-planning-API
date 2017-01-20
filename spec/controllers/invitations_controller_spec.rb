require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let(:organizer) { create(:user) }
  let(:event) { create(:event, organizer: organizer) }

  let(:valid_attributes) do
    FactoryGirl.build(:invitation, event: event).attributes
  end

  describe "POST #create" do
    context "if current_user is organizer of event" do
      before(:each) do
        @auth_headers = organizer.create_new_auth_token
      end

      it "returns http success" do
        post :create, params: { event_id: event.id, 
          invitation: valid_attributes}.merge(@auth_headers)
        expect(response).to have_http_status(:success)
      end

      it "creates a new Invitation" do
        expect {
          post :create, params: {event_id: event.id, 
            invitation: valid_attributes}.merge(@auth_headers)
        }.to change(Invitation, :count).by(1)
      end

      it "assigns a newly created invitation as @invitation" do
        post :create, params: {event_id: event.id, 
          invitation: valid_attributes}.merge(@auth_headers)
        expect(assigns(:invitation)).to be_a(Invitation)
        expect(assigns(:invitation)).to be_persisted
      end
    end

    context "if current_user is participant of event" do
      let(:participant) { create(:user) } 
      before(:each) do
        create(:invitation, event: event, user: participant)
        @participant_auth_headers = participant.create_new_auth_token
      end

      it "returns http success" do
        post :create, params: { event_id: event.id, 
          invitation: valid_attributes}.merge(@participant_auth_headers)
        expect(response).to have_http_status(:success)
      end

      it "creates a new Invitation" do
        expect {
          post :create, params: {event_id: event.id, 
            invitation: valid_attributes}.merge(@participant_auth_headers)
        }.to change(Invitation, :count).by(1)
      end      
    end

    context "if current_user is not participant of event" do
      let(:user) { create(:user) }
      let(:invalid_auth_headers) { user.create_new_auth_token }

      it "raises an error and does not create a new Invitation" do
        expect {
          post :create, params: { event_id: event.id, 
            invitation: valid_attributes}.merge(invalid_auth_headers)
        }.to raise_error(SecurityError)
        expect(Invitation.count).to eq(0)
      end
    end
  end

end