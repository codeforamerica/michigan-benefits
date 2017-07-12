# frozen_string_literal: true

class Mom
  def user(name = "user-#{sequence}", email: "#{name.to_s.underscore.dasherize.parameterize}@example.com", password: 'password', admin: false)
    User.new(name: name, email: email, password: password, admin: admin)
  end

  def admin
    user "admin-#{sequence}", admin: true
  end

  def member
    user "member-#{sequence}"
  end

  private

  def sequence
    @sequence ||= 0
    @sequence += 1
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
