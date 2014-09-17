FactoryGirl.define do
  factory :wholesale_customer do
    name "Lanes"

    trait :with_order do
      after(:build) {|w| w.orders << FactoryGirl.build(:order, wholesale_customer: w) }
    end
  end
end
