FactoryGirl.define do

NEW_SUB_BODY ="Welcome {{subscriber.name}}!
  Let us know if your details are incorrect, phone: {{subscriber.phone}}, address: {{subscriber.address}}
  You will be getting  bread(s) {{bread_types}}
  from {{collection_point.name}}, {{collection_point.address}}, {{collection_point.post_code}} on {{subscriber.collection_day_name}}, but we need three days to get an order started so if its closer than 3 days it will be next week.".gsub(/^\s*/,'')

  factory :collection_point do
    name "Green Action"
    address "LUU"
    post_code "LS2 .."
  end

  factory :bread_type do
    name "White sour"
    sour_dough true

  end

  factory :yeast_bread, class: BreadType do
    name "Ciabatta"
    sour_dough false
  end

  factory :subscriber do
    name "Lizzie"
    sequence(:email) {|n| "lizzie#{n}@test.com"}
    phone "0113 0000000"
    collection_point
    password "password"

    trait :admin do
      admin true
      email "admin@example.com"
    end

    trait :subscription do
      after(:build) {|s| s.subscriber_items << FactoryGirl.build(:subscriber_item, subscriber: s) }
    end

    trait :on_subscription_holiday do
      after(:create) do |s|
        s.subscriber_items << FactoryGirl.create(:subscriber_item, subscriber: s)
        s.holidays << FactoryGirl.create(:holiday, subscriber: s)
      end
    end
  end

  factory :subscriber_item do
    bread_type
    subscriber
    collection_day 5
    paid true
  end

  factory :email_template do
    name 'new_sub'
    body 'Welcome!'

    trait :with_real_template do
      body NEW_SUB_BODY
    end
  end

  factory :wholesale_customer do
    name "Lanes"
  end

  factory :holiday do
    subscriber
    start_date Date.tomorrow.beginning_of_week.next_week
    end_date (Date.tomorrow.beginning_of_week + 19.days)
  end
end

