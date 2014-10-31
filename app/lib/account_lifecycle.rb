class AccountLifecycle
  AUTOMATICALLY_ADMINS = YAML.load_file(
    Rails.root.join("config", "automatically_admins.yml")
  ).to_set

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
    account.roles = [Role.admin] if AUTOMATICALLY_ADMINS.include? account.email
    account.save
  end

  def reset_password?(password)
    account.password_required = true
    account.change_password!(password)
  end
end
