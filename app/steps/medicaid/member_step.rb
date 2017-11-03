module Medicaid
  class MemberStep < Step
    def member
      @_member ||= Member.find(member_id)
    end
  end
end
