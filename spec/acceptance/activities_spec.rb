require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "7. Feed" do
  let(:organizer) { create(:user, name: "Organizer") }
  let(:participant) { create(:user, name: "Participant") }
  
  before do
    header "Content-Type", "application/json"
    auth_headers = participant.create_new_auth_token
    header "access-token", auth_headers["access-token"]
    header "client", auth_headers["client"]
    header "uid", auth_headers["uid"]
    @event = create(:event)
    @event.create_activity :create, owner: organizer, 
      event_id: @event.id, recipient: @event
    @invitation = create(:invitation, event: @event, user: participant)
    @invitation.create_activity :create, owner: organizer, 
      event_id: @event.id, recipient: participant
  end

  get "/api/feed" do

    example "1. Get feed" do
      do_request

      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(json.length).to eq(2)
      expect(json[0]["key"]).to eq("invitation.create")
      expect(json[1]["key"]).to eq("event.create")
    end    
  end 
end