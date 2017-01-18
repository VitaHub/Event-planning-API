require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "GET #index" do
    let(:event) { create(:event) }

    it "returns http success" do
      get :index, params: { event_id: event.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    let(:event) { create(:event) }

    let(:valid_attributes) do
      FactoryGirl.build(:comment, event: event).attributes
    end

    it "returns http success" do
      post :create, params: { event_id: event.id, comment: valid_attributes}
      expect(response).to have_http_status(:success)
    end

    context "with valid params" do
      it "creates a new Comment" do
        expect {
          post :create, params: {event_id: event.id, comment: valid_attributes} #, session: valid_session
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        post :create, params: {event_id: event.id, comment: valid_attributes} #, session: valid_session
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end
    end 
  end
end