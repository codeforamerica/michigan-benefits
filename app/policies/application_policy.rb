class ApplicationPolicy
  module ByRole
    def admin?
      Role.admin?(user)
    end
  end
  include ByRole

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    include ByRole

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if admin?
        resolve_admin
      else
        resolve_generic
      end
    end

    def resolve_admin
      scope
    end

    def resolve_generic
      scope.none
    end
  end
end

