require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  let(:organizer) { create(:user) }
  let(:participant) { create(:user) } 
  let(:user) { create(:user) }

  let(:valid_attributes) {
    FactoryGirl.build(:event, organizer: organizer).attributes
  }

  let(:invalid_attributes) {
    FactoryGirl.build(:event, time: DateTime.yesterday).attributes
  }

  before(:each) do 
    @auth_headers = organizer.create_new_auth_token
    @participant_auth_headers = participant.create_new_auth_token
    @invalid_auth_headers = user.create_new_auth_token    
  end  

  describe "GET #index" do
    it "assigns all events as @events" do
      event = Event.create! valid_attributes
      get :index, params: {}.merge(@auth_headers)
      expect(assigns(:events)).to eq([event])
    end


    context "without params" do
      before(:each) do 
        create(:event, time: DateTime.now + 1.day,
          organizer: organizer)
        create(:event, name: "Test Event 2",
          time: DateTime.now + 2.days, organizer: organizer)
        event_where_participant = create(:event, 
          organizer: user, time: DateTime.now + 3.days)
        create(:invitation, user: organizer, event: event_where_participant)
        create(:event, organizer: user)
        get :index, params: {}.merge(@auth_headers)
      end  

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end    
      
      it "sends a list of events where user is participant" do
        json = JSON.parse(response.body)
        expect(json.length).to eq(3)
      end  

      it "sends a list in a correct order" do
        json = JSON.parse(response.body)
        expect(json.first["name"]).to eq("Test Event 1")
        expect(json.second["name"]).to eq("Test Event 2")
      end  
    end

    context "with params" do
      before(:each) do 
        FactoryGirl.create(:event, time: DateTime.now + 1.day,
          organizer: organizer)
        FactoryGirl.create(:event, name: "Test Event 2",
          time: DateTime.now + 3.days, organizer: organizer)
      end  

      it "sends a list of events in right interval" do
        get :index, params: { interval: "2d" }.merge(@auth_headers)
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json.length).to eq(1)
      end

      it "sends a list of events in due date" do
        get :index, params: { due: DateTime.now + 2.days }.merge(@auth_headers)
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json.length).to eq(1)
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested event as @event" do
      event = Event.create! valid_attributes
      get :show, params: {id: event.to_param}.merge(@auth_headers)
      expect(response).to be_success
      expect(assigns(:event)).to eq(event)
    end

    it "responds success if user is invited at event" do
      event = Event.create! valid_attributes
      event.invitations.create!(user: participant)
      get :show, params: {id: event.to_param}.merge(@participant_auth_headers)
      expect(response).to be_success
    end

    it "fails if user is not invited at event" do
      event = Event.create! valid_attributes
      expect {
        get :show, params: {id: event.to_param}.merge(@invalid_auth_headers)
      }.to raise_error(SecurityError)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, params: {event: valid_attributes}.merge(@auth_headers)
        }.to change(Event, :count).by(1)
      end

      it "assigns a newly created event as @event" do
        post :create, params: {event: valid_attributes}.merge(@auth_headers)
        expect(assigns(:event)).to be_a(Event)
        expect(assigns(:event)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved event as @event" do
        post :create, params: {event: invalid_attributes}.merge(@auth_headers)
        expect(assigns(:event)).to be_a_new(Event)
      end
    end
  end

  describe "PUT #update" do
    let(:new_attributes) {
      FactoryGirl.build(:event, name: "Some Other Event").attributes
    }

    context "with valid params" do

      it "updates the requested event" do
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param, 
          event: new_attributes}.merge(@auth_headers)
        event.reload
        expect(assigns(:event).name).to eq("Some Other Event")
      end

      it "assigns the requested event as @event" do
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param,
          event: valid_attributes}.merge(@auth_headers)
        expect(response).to be_success
        expect(assigns(:event)).to eq(event)
      end
    end

    context "with invalid params" do
      it "assigns the event as @event" do
        event = Event.create! valid_attributes
        put :update, params: { id: event.to_param,
          event: invalid_attributes }.merge(@auth_headers)
        expect(assigns(:event)).to eq(event)
      end

      it "does not update the requested event if user invalid" do
        event = Event.create! valid_attributes
        expect {
          put :update, params: {id: event.to_param, 
            event: new_attributes}.merge(@invalid_auth_headers)
        }.to raise_error(SecurityError)
        expect(assigns(:event)).to eq(event)
      end      
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested event" do
      event = Event.create! valid_attributes
      expect {
        delete :destroy, params: {id: event.to_param}.merge(@auth_headers)
      }.to change(Event, :count).by(-1)
    end

    it "does not destroy the requested event if user invalid" do
      event = Event.create! valid_attributes
      expect {
        delete :destroy, params: {id: event.to_param}.merge(@invalid_auth_headers)
      }.to raise_error(SecurityError)
      expect(Event.count).to eq(1)
    end
  end

end
