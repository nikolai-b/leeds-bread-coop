FactoryGirl.define do
  factory :subscriber do
    first_name "Lizzie"
    last_name  "Surname"
    sequence(:email) {|n| "lizzie#{n}@test.com"}
    phone "0113 0000000"
    collection_point
    password "password"

    trait :admin do
      admin true
      email "admin@example.com"
    end

    trait :with_subscription do
      after(:build) {|s| s.subscriber_items << FactoryGirl.build(:subscriber_item, subscriber: s) }
    end

    trait :on_subscription_holiday do
      after(:create) do |s|
        s.subscriber_items << FactoryGirl.create(:subscriber_item, subscriber: s)
        s.holidays << FactoryGirl.create(:holiday, subscriber: s)
      end
    end
  end
end

