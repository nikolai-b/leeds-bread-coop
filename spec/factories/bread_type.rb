FactoryGirl.define do
  factory :bread_type do
    name "White Sourdough"
    sour_dough true
    wholesale_only false

    trait :yeasty do
      name "Ciabatta"
      sour_dough false
    end
  end
end
