require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  let(:valid_attributes) {
    FactoryGirl.build(:event).attributes
  }

  let(:invalid_attributes) {
    FactoryGirl.build(:event, time: DateTime.yesterday).attributes
  }

  # let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all events as @events" do
      event = Event.create! valid_attributes
      get :index, params: {} #, session: valid_session
      expect(assigns(:events)).to eq([event])
    end

    context "without params" do
      before(:each) do 
        FactoryGirl.create(:event, time: DateTime.now + 1.day)
        FactoryGirl.create(:event, name: "Test Event 2",
          time: DateTime.now + 2.days)
        get :index
      end  

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end    
      
      it "sends a list of events" do
        json = JSON.parse(response.body)
        expect(json.length).to eq(2)
      end  

      it "sends a list with a correct order" do
        json = JSON.parse(response.body)
        expect(json.first["name"]).to eq("Test Event 1")
        expect(json.second["name"]).to eq("Test Event 2")
      end  
    end

    context "with params" do
      before(:each) do 
        FactoryGirl.create(:event, time: DateTime.now + 1.day)
        FactoryGirl.create(:event, name: "Test Event 2",
          time: DateTime.now + 3.days)
      end  

      it "sends a list of events in right interval" do
        get :index, params: { interval: "2d" }
        json = JSON.parse(response.body)
        expect(json.length).to eq(1)
      end

      it "sends a list of events in due date" do
        get :index, params: { due: DateTime.now + 2.days }
        json = JSON.parse(response.body)
        expect(json.length).to eq(1)
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested event as @event" do
      event = Event.create! valid_attributes
      get :show, params: {id: event.to_param} #, session: valid_session
      expect(assigns(:event)).to eq(event)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, params: {event: valid_attributes} #, session: valid_session
        }.to change(Event, :count).by(1)
      end

      it "assigns a newly created event as @event" do
        post :create, params: {event: valid_attributes} #, session: valid_session
        expect(assigns(:event)).to be_a(Event)
        expect(assigns(:event)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved event as @event" do
        post :create, params: {event: invalid_attributes} #, session: valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        FactoryGirl.build(:event, name: "Some Other Event").attributes
      }

      it "updates the requested event" do
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param, event: new_attributes} #, session: valid_session
        event.reload
        expect(assigns(:event).name).to eq("Some Other Event")
      end

      it "assigns the requested event as @event" do
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param, event: valid_attributes} #, session: valid_session
        expect(assigns(:event)).to eq(event)
      end
    end

    context "with invalid params" do
      it "assigns the event as @event" do
        event = Event.create! valid_attributes
        put :update, params: {id: event.to_param, event: invalid_attributes} #, session: valid_session
        expect(assigns(:event)).to eq(event)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested event" do
      event = Event.create! valid_attributes
      expect {
        delete :destroy, params: {id: event.to_param} #, session: valid_session
      }.to change(Event, :count).by(-1)
    end
  end

end
