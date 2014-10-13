module AccountCreator
  AUTOMATICALLY_ADMINS = YAML.load_file(
    Rails.root.join("config", "automatically_admins.yml")
  ).to_set

  def self.create(attrs)
    account = Account.new(attrs)
    account.roles = [Role.admin] if AUTOMATICALLY_ADMINS.include? account.email
    account.save
    account
  end
end
