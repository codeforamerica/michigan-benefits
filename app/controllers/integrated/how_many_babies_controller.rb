module Integrated
  class HowManyBabiesController < MemberPerPageController
    def self.skip?(application)
      !application.navigator.anyone_pregnant?
    end

    def update_models
      current_member.update(member_params.slice(:baby_count))
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
