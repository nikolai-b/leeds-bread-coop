FactoryGirl.define do
  factory :wholesale_customer do
    name "Lanes"

    trait :with_regular_order do
      after(:build) {|w| w.orders << FactoryGirl.build(:order, wholesale_customer: w) }
    end

    trait :with_nonregular_order do
      after(:build) {|w| w.orders << FactoryGirl.build(:order, wholesale_customer: w, regular: false) }
    end
  end
end
