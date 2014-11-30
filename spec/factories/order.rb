FactoryGirl.define do
  factory :order do
    wholesale_customer
    date Date.today + 4.days
    after(:build) {|o| o.line_items << FactoryGirl.build(:line_item, order: o) }
  end
end

