require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "6. Users" do
  let(:user) { create(:user, name: "Superman") }
  before(:each) do
    header "Content-Type", "application/json"
    auth_headers = user.create_new_auth_token
    header "access-token", auth_headers["access-token"]
    header "client", auth_headers["client"]
    header "token-type", auth_headers["token-type"]
    header "uid", auth_headers["uid"]
  end

  get "/api/users/:id" do
    let(:id) { user.id }

    example "1. Show the user" do
      do_request

      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(json["name"]).to eq(user.name)
    end    
  end 
end