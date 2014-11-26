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
      after(:build) {|s| s.subscriptions << FactoryGirl.build(:subscription, subscriber: s) }
    end

    trait :with_payment_card do
      after(:build) {|s| s.payment_card = FactoryGirl.build(:payment_card, subscriber: s) }
    end

    trait :on_subscription_holiday do
      after(:create) do |s|
        s.subscriptions << FactoryGirl.create(:subscription, subscriber: s)
        s.holidays << FactoryGirl.create(:holiday, subscriber: s)
      end
    end
  end
end

