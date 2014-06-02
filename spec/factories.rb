FactoryGirl.define do

NEW_SUB_BODY ="Welcome {{subscriber.name}}!
  Let us know if your details are incorrect, phone: {{subscriber.phone}}, address: {{subscriber.address}}
  You will be getting your bread {{bread_type}} from {{collection_point.name}}, {{collection_point.address}}, {{collection_point.post_code}} on {{subscriber.day_of_week}} starting on {{subscriber.start_date}}
".gsub(/^\s*/,'')

  factory :collection_point do
    name "Green Action"
    address "LUU"
    post_code "LS2 .."
  end

  factory :bread_type do
    name "Rye Sour Loaf"
  end

  factory :subscriber do
    sequence(:name) {|n| "Lizzie #{n}"}
    sequence(:email) {|n| "lizzie#{n}@test.com"}
    phone "0113 ..."
    collection_point
    start_date ((Date.current + 7.days).beginning_of_week + 2.days) # next Wendsday
    bread_type
    password "password"

    trait :paid do
      has_active_sub true
      sequence(:start_date) {|n| Date.current.beginning_of_week - 10.days - n.weeks } # Fri
    end
  end

  factory :email_template do
    name 'new_sub'
    body 'Welcome!'
  end

  factory :new_sub_template, class: EmailTemplate do
    name 'new_sub'
    body NEW_SUB_BODY
  end



end

