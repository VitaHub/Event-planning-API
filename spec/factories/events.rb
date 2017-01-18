FactoryGirl.define do
  factory :event do
    name "Test Event 1"
    organizer_id 1
    time DateTime.now + 1.day
    place "Lviv"
    description "Some description"
  end
end
