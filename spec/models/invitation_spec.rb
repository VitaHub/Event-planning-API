require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe "invitation" do
    before(:each) { @invitation = create(:invitation) }

    it "should be created" do
      expect(@invitation).to be_valid
      expect(Invitation.count).to eq(1)
    end

    it "should not be duplicated" do
      other_invitation = @invitation.dup
      expect(other_invitation).not_to be_valid
      expect(Invitation.count).to eq(1)
    end  

    it "should not be created if user does not exist" do
      expect {
        create(:invitation, user_id: 1)
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Invitation.count).to eq(1)
    end 

    it "should not be created if event does not exist" do
      expect {
        create(:invitation, event_id: 1)
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Invitation.count).to eq(1)
    end 
  end
end