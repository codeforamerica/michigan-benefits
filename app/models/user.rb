class User < ApplicationRecord
  authenticates_with_sorcery!

  before_save { email.try(:downcase!) }

  has_one :app

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }

end
