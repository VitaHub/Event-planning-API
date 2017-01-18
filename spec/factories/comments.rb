FactoryGirl.define do
  factory :comment do
    user
    event
    text "Some comment"
  end
end
