module Integrated
  class HouseholdMembersOverviewController < FormsController
    def self.custom_skip_rule_set(application)
      !application.navigator.applying_for_food?
    end

    def form_class
      NullStep
    end
  end
end
