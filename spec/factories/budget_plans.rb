FactoryBot.define do
  factory :budget_plan do
    name { "MyString" }
    amount { "9.99" }
    period_start { "2025-06-26" }
    period_end { "2025-06-26" }
    user { nil }
  end
end
