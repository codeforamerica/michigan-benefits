class Account < ApplicationRecord
  CASH_ACCOUNTS = {
    checking: "Checking",
    savings: "Savings",
  }.freeze

  OTHER_ACCOUNTS = {
    payroll_benefits: "Payroll/Benefits card",
    retirement: "Retirement plan",
    "401k": "401k account",
    life_insurance: "Life insurance",
    stocks: "Stocks",
    mutual_funds: "Mutual fund",
    ira: "IRA",
    cd: "Certificate of Deposit",
    burial: "Burial fund",
    winnings: "Lottery/Gambling winnings",
    trust: "Trust/Annuity",
    other: "Other account",
  }.freeze

  has_and_belongs_to_many :members,
    -> { order(created_at: :asc) },
    class_name: "HouseholdMember",
    foreign_key: "account_id"

  scope :cash, -> {
    where(account_type: CASH_ACCOUNTS.keys)
  }

  scope :other, -> {
    where(account_type: OTHER_ACCOUNTS.keys)
  }

  def self.all_accounts
    CASH_ACCOUNTS.merge(**OTHER_ACCOUNTS)
  end

  def self.all_account_types
    all_accounts.keys
  end

  validates :account_type, inclusion: { in: all_account_types.map(&:to_s),
                                        message: "%<value>s is not a valid account type" }

  def display_name
    all_accounts[account_type.to_sym]
  end

  delegate :all_accounts, to: :class
end
