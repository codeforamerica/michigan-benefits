class Role < ActiveRecord::Base
  has_many :account_roles
  has_many :accounts, through: :account_roles

  validates :key, uniqueness: true
  validates :name, :key, presence: true
end
