require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:organizer) { create(:user) }
  let(:event) { create(:event, organizer: organizer) }
  let(:auth_headers) { organizer.create_new_auth_token }
  let(:valid_attributes) do
    FactoryGirl.build(:comment, event: event).attributes
  end


  describe "GET #index" do
    it "returns http success" do
      get :index, params: { event_id: event.id }.merge(auth_headers)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "returns http success" do
      post :create, params: { event_id: event.id, 
        comment: valid_attributes}.merge(auth_headers)
      expect(response).to have_http_status(:success)
    end

    it "creates a new Comment" do
      expect {
        post :create, params: {event_id: event.id, 
          comment: valid_attributes}.merge(auth_headers)
      }.to change(Comment, :count).by(1)
    end

    it "assigns a newly created comment as @comment" do
      post :create, params: {event_id: event.id, 
        comment: valid_attributes}.merge(auth_headers)
      expect(assigns(:comment)).to be_a(Comment)
      expect(assigns(:comment)).to be_persisted
    end
  end
end