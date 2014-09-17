FactoryGirl.define do
  factory :order do
    date Date.tomorrow.beginning_of_week.next_week
    after(:build) {|o| o.line_items << FactoryGirl.build(:line_item, order: o) }
  end
end

