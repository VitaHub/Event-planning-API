require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "1. Authentication" do
  header "Content-Type", "application/json"
  
  post "/api/auth" do
    let!(:request_attributes) {
      { 
        name: "TestUser",
        nickname: "testname",
        email: "test@gmail.com",
        password: "testpass",
        password_confirmation: "testpass"
      }
    }    

    example "1. Sign Up" do
      do_request(request_attributes)

      expect(status).to eq 200
      file = JSON.parse(response_body).fetch("data")
      expect(file["name"]).to eq("TestUser")
      expect(file["id"]).to be_present
    end
  end

  get "/api/auth/confirmation" do
    let(:user_attributes) { FactoryGirl.build(:user).attributes }
    let(:user) { User.create! user_attributes.merge(
      password: "testpass", 
      password_confirmation: "testpass") }
    let!(:request_attributes) {
      { config: "default",
      confirmation_token: user.confirmation_token,
      redirect_url: "example.org" }
    }

    example "2. Account confirmation" do
      expect(User.last.confirmed_at).not_to be_present
      do_request(request_attributes)

      expect(status).to eq 302
      expect(User.last.confirmed_at).to be_present
    end
  end
  post "/api/auth/sign_in" do
    let(:user) { create(:user) }
    let!(:request_attributes) {
      { 
        email: user.email,
        password: "testpass",
        password_confirmation: "testpass"
      }
    }    
=begin
    example "Sign In from unconfirmed account" do
      do_request(request_attributes)
      expect(status).to eq 401

      file = JSON.parse(response_body).fetch("errors")
      expect(file[0]).to match(/A confirmation email was sent/)
    end
=end
    example "3. Sign In" do
      user.confirmed_at = DateTime.now
      user.save!
      do_request(request_attributes)
      expect(status).to eq 200

      body = JSON.parse(response_body).fetch("data")
      expect(body["email"]).to eq(user.email)
      expect(response_headers["access-token"]).to be_present
      expect(response_headers["client"]).to be_present
      expect(response_headers["token-type"]).to be_present
      expect(response_headers["uid"]).to be_present
    end
  end

  delete "/api/auth/sign_out" do
    let(:user) { create(:user) }
    before do
      auth_headers = user.create_new_auth_token
      header "access-token", auth_headers["access-token"]
      header "client", auth_headers["client"]
      header "token-type", auth_headers["token-type"]
      header "uid", auth_headers["uid"]
    end

    example "5. Log out" do
      do_request

      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(json["success"]).to eq(true)
      expect(response_headers["access-token"]).not_to be_present
    end
  end

  get "/api/auth/github" do
    example "4. Sign in with GitHub account" do
      do_request

      expect(status).to eq 301
      client.get response_headers["Location"]
      client.get response_headers["Location"]
      client.get response_headers["Location"]

      expect(status).to eq 200
      expect(response_headers["access-token"]).to be_present
      expect(response_headers["client"]).to be_present
    end
  end
end