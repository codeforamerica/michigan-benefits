module Integrated
  class DoYouHaveJobController < FormsController
    def self.skip_rule_sets(application)
      [SkipRules.single_member_only(application)]
    end

    def update_models
      if params_for(:navigator)[:current_job] == "false"
        current_application.primary_member.employments.delete_all
      elsif current_application.primary_member.employments.count.zero?
        current_application.primary_member.employments.create
      end

      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
