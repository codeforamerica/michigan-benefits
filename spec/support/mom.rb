class Mom
  def user(name="user-#{sequence}", email: "#{name.to_s.underscore.dasherize.parameterize}@example.com", password: "password")
    User.new(name: name, email: email, password: password)
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
