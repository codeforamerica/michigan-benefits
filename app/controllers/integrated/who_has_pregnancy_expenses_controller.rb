module Integrated
  class WhoHasPregnancyExpensesController < MultipleMembersPerPageController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_pregnancy_expenses?
    end
  end
end
