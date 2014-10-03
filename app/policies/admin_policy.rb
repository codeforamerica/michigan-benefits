class AdminPolicy
  attr_reader :user

  def initialize(user, admin)
    @user = user
  end

  def admin?
    user.roles.include? admin_role
  end

  ADMIN_ROLE_KEY = 'admin'

  private

    def admin_role
      Role.find_by_key(ADMIN_ROLE_KEY)
    end
end
