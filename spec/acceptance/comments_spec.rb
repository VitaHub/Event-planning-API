require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Comments" do
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

  get "/api/events/:event_id/comments" do
    let(:event_id) { event.id }
    before do 
      @comment = create(:comment, event: event, text: "Best Comment ever!")
    end

    example "Get list of comments to event" do
      do_request

      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(json.length).to eq(1)
      expect(json[0]["text"]).to eq(@comment.text)
    end    
  end 

  post "/api/events/:event_id/comments" do
    let(:event_id) { event.id }

    let(:request_params) {
      { comment: { user_id: organizer.id, text: "Best Comment ever!" }}
    }

    example "Creating a new comment to event" do
      do_request(request_params)

      expect(status).to eq 201
      json = JSON.parse(response_body)
      expect(json["text"]).to eq("Best Comment ever!")
    end
  end
end