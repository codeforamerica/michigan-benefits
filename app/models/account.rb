class Account < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :account_roles
  has_many :roles, through: :account_roles

  validates :email, uniqueness: true
end
