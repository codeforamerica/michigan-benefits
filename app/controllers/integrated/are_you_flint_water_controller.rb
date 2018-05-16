module Integrated
  class AreYouFlintWaterController < FormsController
    def self.skip?(application)
      return true unless application.single_member_household?
      member = application.primary_member
      no_skip = member.pregnant_yes? || member.pregnancy_expenses_yes? ||
        member.age.nil? || (member.age && member.age < 21)
      no_skip ? false : true
    end

    def update_models
      current_application.primary_member.update!(params_for(:member))
    end
  end
end
