module Integrated
  class SelfEmploymentDetailsController < MemberPerPageController
    def self.skip?(application)
      application.members.self_employed.none?
    end

    def member_scope
      current_application.members.self_employed
    end
  end
end
