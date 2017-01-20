require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Events" do
  let(:organizer) { create(:user) }
  before(:each) do
    header "Content-Type", "application/json"
    auth_headers = organizer.create_new_auth_token
    header "access-token", auth_headers["access-token"]
    header "client", auth_headers["client"]
    header "token-type", auth_headers["token-type"]
    header "uid", auth_headers["uid"]
  end

  get "/api/events" do
    before(:each) do
      create(:event, organizer: organizer, name: "First Event", 
        time: DateTime.now + 2.days)
      event_where_user_is_participant = create(:event, name: "Second Event",
        time: DateTime.now + 4.days)
      create(:invitation, user: organizer, 
        event: event_where_user_is_participant)
      create(:event, name: "Third Event", time: DateTime.now + 6.days)
    end

    example "Get list of events where current_user is participant" do
      do_request

      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(json.length).to eq(2)
    end

    example "Get list of future events due date" do
      request_params = { time: "future",
        due: (DateTime.now + 3.days).to_s(:number) }
      do_request(request_params)

      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(json.length).to eq(1)
      expect(json[0]["name"]).to eq("First Event")
    end

    example "Get list of future events by interval" do
      request_params = { time: "future", interval: "3d" }
      do_request(request_params)

      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(json.length).to eq(1)
      expect(json[0]["name"]).to eq("First Event")
    end
  end

  get "/api/events/:id" do
    let(:id) { create(:event, organizer: organizer, name: "An event").id }

    example "Show the event" do
      do_request

      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(json["name"]).to eq("An event")      
    end
  end

  post "/api/events" do
    let(:request_params) {
      { event: 
        { name: "My Event", 
        time: (DateTime.now + 10.days).to_s(:number),
        place: "London",
        description: "Some Description" }
      }
    }

    example "Creating a new event" do
      do_request(request_params)

      expect(status).to eq 201
      json = JSON.parse(response_body)
      expect(json["name"]).to eq("My Event")
    end
  end

  put "/api/events/:id" do
    let(:event) { create(:event, organizer: organizer, name: "An event") }
    let(:id) { event.id }
    let(:request_params) {
      { event: 
        { name: "Other Event", 
        time: event.time.to_s(:number),
        place: event.place,
        description: event.description }
      }
    }

    example "Updating the event" do
      do_request(request_params)

      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(json["name"]).to eq("Other Event")
    end   
  end

  delete "/api/events/:id" do
    let(:event) { create(:event, organizer: organizer, name: "An event") }
    let(:id) { event.id }

    example "Deleting the event" do
      do_request

      expect(status).to eq 204
    end    
  end
end