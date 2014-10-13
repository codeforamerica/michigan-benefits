class AdminPolicy
  attr_reader :user

  def initialize(user, admin)
    @user = user
  end

  def admin?
    user.roles.include? Role.admin
  end
end
