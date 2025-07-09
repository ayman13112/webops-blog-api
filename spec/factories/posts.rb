FactoryBot.define do
  factory :post do
    title { "MyString" }
    body { "MyText" }
    tags { "MyString" }
    user { nil }
  end
end
