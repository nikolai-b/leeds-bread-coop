FactoryGirl.define do
  factory :subscription do
    bread_type
    subscriber
    collection_day 4
    paid_till { 1.year.from_now }
  end
end
