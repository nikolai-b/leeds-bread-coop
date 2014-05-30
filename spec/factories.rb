FactoryGirl.define do
  factory :collection_point do
    name "Green Action"
  end

  factory :bread_type do
    name "Rye Sour Loaf"
  end

  factory :subscriber do
    name "Lizzie"
    email "lizzie@test.com"
    phone "0113 ..."
    collection_point_id 1
    start ((Date.current + 7.days).beginning_of_week + 2.days) # next Wendsday
    bread_type_id 1
    password "password"
  end
end

