class Account < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :account_roles
  has_many :roles, through: :account_roles

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
end
