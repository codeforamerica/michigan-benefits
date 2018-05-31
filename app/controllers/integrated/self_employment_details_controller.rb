module Integrated
  class SelfEmploymentDetailsController < MemberPerPageController
    def self.custom_skip_rule_set(application)
      application.members.self_employed.none?
    end

    def member_scope
      current_application.members.self_employed
    end
  end
end
