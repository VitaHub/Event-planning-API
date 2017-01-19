require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Attachments" do

  get "/api/events/:event_id/attachments" do
    let(:event_id) { create(:event).id }

    example " Get listing of attachments" do
      do_request

      expect(status).to eq 200
    end
  end

  post "/api/events/:event_id/attachments" do
    let(:event_id) { create(:event).id }
    let(:user_id) { create(:user).id }
    let!(:request_attributes) {
      { attachment: { user_id: user_id, 
        file: "data:image/png;base64, iVBORw0KGgoAAAANSUhE==" }}
    }    

    example "Posting an attachment" do
      do_request(request_attributes)
      expect(status).to eq 201

      file = JSON.parse(response_body).fetch("file")
      expect(file["url"]).to be_present
    end
  end
end