class Mom
  def account(email: 'bob@example.com', password: 'a password')
    Account.new email: email, password: password
  end

  def role(name: 'A Role', key: nil)
    Role.new name: name, key: (key || name)
  end

  def admin_role
    role name: 'Admin', key: Role::ADMIN_ROLE_KEY
  end

  def account_role(account, role)
    AccountRole.new account: account, role: role
  end
end

def mom
  @mom ||= Mom.new
end

def build(thing, *args)
  mom.send(thing, *args)
end

def create(thing, *args)
  mom.send(thing, *args).tap(&:save!)
end
