FactoryGirl.define do
  factory :holiday do
    subscriber
    start_date (Date.tomorrow.beginning_of_week + 14.days)
    end_date (Date.tomorrow.beginning_of_week + 26.days)
  end
end
