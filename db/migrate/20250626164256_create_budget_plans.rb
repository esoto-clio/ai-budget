class CreateBudgetPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :budget_plans do |t|
      t.string :name
      t.decimal :amount
      t.date :period_start
      t.date :period_end
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
