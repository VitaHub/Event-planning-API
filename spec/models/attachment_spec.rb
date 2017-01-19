require 'rails_helper'

RSpec.describe Attachment, type: :model do
  let(:attachment) { create(:attachment) }

  it "should be created" do
    expect(attachment).to be_valid
    expect(Attachment.count).to eq(1)
  end

  it "should not be created if user does not exist" do
    expect {
      create(:attachment, user_id: 1)
    }.to raise_error(ActiveRecord::RecordInvalid)
    expect(Attachment.count).to eq(0)
  end 

  it "should not be created if event does not exist" do
    expect {
      create(:attachment, event_id: 1)
    }.to raise_error(ActiveRecord::RecordInvalid)
    expect(Attachment.count).to eq(0)
  end 

  it "should not be created if file is nil" do
    expect {
      create(:attachment, file: nil)
    }.to raise_error(ActiveRecord::StatementInvalid)
    expect(Attachment.count).to eq(0)
  end 
end
