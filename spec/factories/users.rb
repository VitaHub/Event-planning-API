FactoryGirl.define do
  factory :user do
    name "MyString"
    sequence(:email) { |n| "test#{n}@test.com" }
    password "testpass"
  end
end
