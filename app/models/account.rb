class Account < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :email, uniqueness: true
end
