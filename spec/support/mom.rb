class Mom
  def user(name="user-#{sequence}")
    User.new(name: name, email: "#{name.to_s.underscore.dasherize.parameterize}@example.com", password: "password")
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
