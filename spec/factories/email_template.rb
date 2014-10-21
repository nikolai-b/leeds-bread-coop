FactoryGirl.define do

NEW_SUB_BODY ="Welcome {{subscriber.first_name}}!
  {{#subscriptions}}
    {{collection_day_name}}
  {{/subscriptions}}
  Let us know if your details are incorrect, phone: {{subscriber.phone}}, address: {{subscriber.address}}
  You will be getting  bread(s) {{bread_types}}
  from {{collection_point.name}}, {{collection_point.address}}, {{collection_point.post_code}} on {{subscriber.collection_day_name}}, but we need three days to get an order started so if its closer than 3 days it will be next week.".gsub(/^\s*/,'')

  factory :email_template do
    name 'new_sub'
    body 'Welcome!'

    trait :with_real_template do
      body NEW_SUB_BODY
    end
  end
end
