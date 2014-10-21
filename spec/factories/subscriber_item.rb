FactoryGirl.define do
  factory :subscription do
    bread_type
    subscriber
    collection_day 5
    paid true
  end
end
