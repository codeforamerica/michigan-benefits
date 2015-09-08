class Account < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :account_roles
  has_many :roles, through: :account_roles

  before_save { email.try(:downcase!) }

  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validates :password, length: { minimum: 8 }, if: :password_required?

  attr_writer :password_required

  def password_required?
    @password_required
  end

  def authenticate(password)
    # Passing email is a bit strange, but sorcery doesn't
    # provide a way to ask an instance whether a password is valid
    self.class.authenticate(email, password)
  end
end
