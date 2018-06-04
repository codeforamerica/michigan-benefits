module Integrated
  class HowManyBabiesController < MemberPerPageController
    def self.custom_skip_rule_set(application)
      !application.navigator.anyone_pregnant?
    end

    def update_models
      current_member.update(params_for(:member).slice(:baby_count))
    end

    private

    def member_scope
      current_application.
        members.
        pregnant
    end

    def set_default_values
      current_member.baby_count ||= 1
    end
  end
end
