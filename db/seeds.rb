# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create sample user
user = User.find_or_create_by!(email: "demo@budget.app") do |u|
  u.name = "Demo User"
end

puts "Created user: #{user.name}"

# Create categories with colors
categories_data = [
  { name: "Food & Dining", color: "#EF4444" },
  { name: "Transportation", color: "#F97316" },
  { name: "Shopping", color: "#F59E0B" },
  { name: "Entertainment", color: "#10B981" },
  { name: "Bills & Utilities", color: "#3B82F6" },
  { name: "Healthcare", color: "#6366F1" },
  { name: "Travel", color: "#8B5CF6" },
  { name: "Salary", color: "#10B981" },
  { name: "Freelance", color: "#059669" },
  { name: "Investments", color: "#0D9488" }
]

categories = categories_data.map do |cat_data|
  user.categories.find_or_create_by!(name: cat_data[:name]) do |category|
    category.color = cat_data[:color]
  end
end

puts "Created #{categories.count} categories"

# Create a current budget plan
current_budget = user.budget_plans.find_or_create_by!(
  name: "Monthly Budget - #{Date.current.strftime('%B %Y')}"
) do |budget|
  budget.amount = 3000.00
  budget.period_start = Date.current.beginning_of_month
  budget.period_end = Date.current.end_of_month
end

puts "Created budget plan: #{current_budget.name}"

# Create sample transactions
expense_categories = categories.reject { |c| %w[Salary Freelance Investments].include?(c.name) }
income_categories = categories.select { |c| %w[Salary Freelance Investments].include?(c.name) }

# Income transactions
income_transactions = [
  { description: "Monthly Salary", amount: 4500.00, category: income_categories.find { |c| c.name == "Salary" }, date: Date.current.beginning_of_month + 1.day },
  { description: "Freelance Project", amount: 800.00, category: income_categories.find { |c| c.name == "Freelance" }, date: Date.current - 5.days },
  { description: "Stock Dividend", amount: 150.00, category: income_categories.find { |c| c.name == "Investments" }, date: Date.current - 10.days }
]

income_transactions.each do |transaction_data|
  user.transactions.find_or_create_by!(
    description: transaction_data[:description],
    date: transaction_data[:date]
  ) do |transaction|
    transaction.amount = transaction_data[:amount]
    transaction.transaction_type = 'income'
    transaction.category = transaction_data[:category]
  end
end

# Expense transactions
expense_transactions = [
  { description: "Grocery Shopping", amount: 120.50, category: expense_categories.find { |c| c.name == "Food & Dining" }, date: Date.current - 1.day },
  { description: "Gas Station", amount: 45.00, category: expense_categories.find { |c| c.name == "Transportation" }, date: Date.current - 2.days },
  { description: "Netflix Subscription", amount: 15.99, category: expense_categories.find { |c| c.name == "Entertainment" }, date: Date.current - 3.days },
  { description: "Electric Bill", amount: 89.23, category: expense_categories.find { |c| c.name == "Bills & Utilities" }, date: Date.current - 4.days },
  { description: "Coffee Shop", amount: 12.75, category: expense_categories.find { |c| c.name == "Food & Dining" }, date: Date.current - 5.days },
  { description: "Online Shopping", amount: 67.99, category: expense_categories.find { |c| c.name == "Shopping" }, date: Date.current - 6.days },
  { description: "Movie Tickets", amount: 24.00, category: expense_categories.find { |c| c.name == "Entertainment" }, date: Date.current - 7.days },
  { description: "Lunch", amount: 18.50, category: expense_categories.find { |c| c.name == "Food & Dining" }, date: Date.current - 8.days },
  { description: "Uber Ride", amount: 15.30, category: expense_categories.find { |c| c.name == "Transportation" }, date: Date.current - 9.days },
  { description: "Pharmacy", amount: 34.67, category: expense_categories.find { |c| c.name == "Healthcare" }, date: Date.current - 10.days }
]

expense_transactions.each do |transaction_data|
  user.transactions.find_or_create_by!(
    description: transaction_data[:description],
    date: transaction_data[:date]
  ) do |transaction|
    transaction.amount = transaction_data[:amount]
    transaction.transaction_type = 'expense'
    transaction.category = transaction_data[:category]
  end
end

puts "Created #{income_transactions.count} income transactions"
puts "Created #{expense_transactions.count} expense transactions"

# Create historical budget plans
last_month_budget = user.budget_plans.find_or_create_by!(
  name: "Monthly Budget - #{1.month.ago.strftime('%B %Y')}"
) do |budget|
  budget.amount = 2800.00
  budget.period_start = 1.month.ago.beginning_of_month
  budget.period_end = 1.month.ago.end_of_month
end

puts "Created historical budget: #{last_month_budget.name}"

puts "\n✅ Sample data created successfully!"
puts "👤 User: #{user.name} (#{user.email})"
puts "📊 Categories: #{user.categories.count}"
puts "💰 Budget Plans: #{user.budget_plans.count}"
puts "📝 Transactions: #{user.transactions.count}"
puts "   - Income: #{user.transactions.income.count}"
puts "   - Expenses: #{user.transactions.expenses.count}"
puts "💲 Current Balance: $#{user.net_balance}"
