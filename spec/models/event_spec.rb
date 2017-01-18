require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "event" do 

    it "should be created" do
      create(:event)
      expect(Event.count).to eq(1)
    end

    it "should not be created if description.length > 500" do
      expect {
        create(:event, description: "a" * 501)
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Event.count).to eq(0)
    end

    it "should not be created if time is not in future" do
      expect {
        create(:event, time: DateTime.yesterday)
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Event.count).to eq(0)
    end
  end
end