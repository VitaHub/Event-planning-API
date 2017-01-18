require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }

  it "should be created" do
    expect(comment).to be_valid
    expect(Comment.count).to eq(1)
  end

  it "should not be created if user does not exist" do
    expect {
      create(:comment, user_id: 1)
    }.to raise_error(ActiveRecord::RecordInvalid)
    expect(Comment.count).to eq(0)
  end 

  it "should not be created if event does not exist" do
    expect {
      create(:comment, event_id: 1)
    }.to raise_error(ActiveRecord::RecordInvalid)
    expect(Comment.count).to eq(0)
  end 

  it "should not be created if text is nil" do
    expect {
      create(:comment, text: nil)
    }.to raise_error(ActiveRecord::RecordInvalid)
    expect(Comment.count).to eq(0)
  end 
end
