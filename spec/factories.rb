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
    collection_day 3
    password "password"

    trait :paid do
      num_paid_subs 1
      collection_day_updated_at (Date.current - 4.days)
      collection_day 5
    end

    trait :admin do
      admin true
      email "admin@example.com"
    end
  end

  factory :subscriber_item do
    bread_type
    subscriber
  end

  factory :email_template do
    name 'new_sub'
    body 'Welcome!'
  end

  factory :new_sub_template, class: EmailTemplate do
    name 'new_sub'
    body NEW_SUB_BODY
  end

  factory :wholesale_customer do
    name "Lanes"
  end

end

