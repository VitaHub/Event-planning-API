require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Authentication" do
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

    example "Sign Up" do
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

    example "User confirmation" do
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

    example "Sign In from unconfirmed account" do
      do_request(request_attributes)
      expect(status).to eq 401

      file = JSON.parse(response_body).fetch("errors")
      expect(file[0]).to match(/A confirmation email was sent/)
    end

    example "Sign In from confirmed account" do
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
end