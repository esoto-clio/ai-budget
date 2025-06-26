FactoryBot.define do
  factory :transaction do
    description { "MyString" }
    amount { "9.99" }
    transaction_type { "MyString" }
    date { "2025-06-26" }
    category { nil }
    user { nil }
  end
end
