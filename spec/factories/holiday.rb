FactoryGirl.define do
  factory :holiday do
    subscriber
    start_date Date.tomorrow.beginning_of_week.next_week
    end_date (Date.tomorrow.beginning_of_week + 19.days)
  end
end
