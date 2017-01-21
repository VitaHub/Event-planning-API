require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "3. Invitations" do
  let(:organizer) { create(:user, name: "Organizer") }
  let(:event) { create(:event, organizer: organizer) }
  let(:participant) { create(:user, name: "Participant") }
  before(:each) do
    @user = create(:user, name: "Just user")
    create(:invitation, event: event, user: participant)
    header "Content-Type", "application/json"
    auth_headers = organizer.create_new_auth_token
    header "access-token", auth_headers["access-token"]
    header "client", auth_headers["client"]
    header "token-type", auth_headers["token-type"]
    header "uid", auth_headers["uid"]
  end

  post "/api/events/:event_id/invitations" do
    let(:event_id) { event.id }

    let(:request_params) {
      { invitation: { user_id: @user.id }}
    }

    example "1. Inviting user to event" do
      do_request(request_params)

      expect(status).to eq 201
      json = JSON.parse(response_body)
      expect(json["user_id"]).to eq(@user.id)
      expect(json["event_id"]).to eq(event.id)
    end
  end

  get "/api/events/:event_id/invited" do
    let(:event_id) { event.id }

    example "2. Get list of users that invited to the event" do
      do_request

      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(json.length).to eq(1)
      expect(json[0]["name"]).to eq(participant.name)
    end    
  end 

  get "/api/events/:event_id/uninvited" do
    let(:event_id) { event.id }

    example "3. Get list of users that not invited to the event" do
      do_request

      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(json.length).to eq(1)
      expect(json[0]["name"]).to eq(@user.name)
    end    
  end 
end