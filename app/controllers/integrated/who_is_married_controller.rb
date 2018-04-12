module Integrated
  class WhoIsMarriedController < MultipleMembersPerPageController
    def self.skip?(application)
      return true if application.single_member_household?
      return true unless application.navigator.anyone_married?
    end
  end
end
