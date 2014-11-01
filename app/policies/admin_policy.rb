class AdminPolicy
  attr_reader :user

  def initialize(user, admin)
    @user = user
  end

  def admin?
    user && user.roles.include?(Role.admin)
  end
end
