FactoryGirl.define do
  factory :event do
    name "Test Event 1"
    association :organizer, factory: :user
    time DateTime.now + 1.day
    place "Lviv"
    description "Some description"
  end
end
