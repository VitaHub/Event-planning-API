require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "5. Attachments" do
  let(:organizer) { create(:user, name: "Organizer") }
  let(:event) { create(:event, organizer: organizer) }
  before(:each) do
    header "Content-Type", "application/json"
    auth_headers = organizer.create_new_auth_token
    header "access-token", auth_headers["access-token"]
    header "client", auth_headers["client"]
    header "token-type", auth_headers["token-type"]
    header "uid", auth_headers["uid"]
  end
  
  get "/api/events/:event_id/attachments" do
    let(:event_id) { event.id }
    before { create(:attachment, event_id: event_id) }

    example "1. Get list of attachments" do
      do_request

      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(json.length).to eq(1)
    end
  end

  post "/api/events/:event_id/attachments" do
    let(:event_id) { event.id }
    let!(:request_attributes) {
      { attachment: { user_id: organizer.id, 
        file: "data:image/png;base64, iVBORw0KGgoAAAANSUhE==" }}
    }    

    example "2. Creating an attachment with file for the event" do
      do_request(request_attributes)
      expect(status).to eq 201

      file = JSON.parse(response_body).fetch("file")
      expect(file["url"]).to be_present
    end
  end
end