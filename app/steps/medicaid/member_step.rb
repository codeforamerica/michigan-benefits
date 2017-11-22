module Medicaid
  class MemberStep < Step
    def member
      @_member ||= Member.find(id)
    end
  end
end
