module Integrated
  class WhoHasPregnancyExpensesController < MultipleMembersController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_pregnancy_expenses?
    end
  end
end
