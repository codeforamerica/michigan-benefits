class AccountLifecycle
  def self.from_reset_token(token)
    new Account.load_from_reset_password_token(token)
  end

  def self.create(attrs)
    lifecycle = new(Account.new)
    lifecycle.create(attrs)
    lifecycle
  end

  def initialize(account)
    @account = account
  end

  attr_reader :account

  def found?
    @account.present?
  end

  def create(attrs)
    account.password_required = true
    account.attributes = attrs
    account.save
  end

  def reset_password?(password)
    account.password_required = true
    account.change_password!(password)
  end
end
