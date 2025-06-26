class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" },
                    length: { maximum: 255 }

  validates :password, length: { minimum: 6 }, allow_nil: true

  # Normalize email to lowercase before saving
  before_save :downcase_email

  # Associations
  has_many :categories, dependent: :destroy
  has_many :budget_plans, dependent: :destroy
  has_many :transactions, dependent: :destroy

  def total_income(start_date = nil, end_date = nil)
    scope = transactions.where(transaction_type: "income")
    scope = scope.where(date: start_date..end_date) if start_date && end_date
    scope.sum(:amount)
  end

  def total_expenses(start_date = nil, end_date = nil)
    scope = transactions.where(transaction_type: "expense")
    scope = scope.where(date: start_date..end_date) if start_date && end_date
    scope.sum(:amount)
  end

  def net_balance(start_date = nil, end_date = nil)
    total_income(start_date, end_date) - total_expenses(start_date, end_date)
  end

  # Full name for display
  def full_name
    name
  end

  # Generate secure session token
  def generate_session_token
    SecureRandom.urlsafe_base64
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
