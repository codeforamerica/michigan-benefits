module Integrated
  class WhoIsNotCitizenController < MultipleMembersPerPageController
    def self.skip?(application)
      return true if application.single_member_household?
      application.navigator.everyone_citizen?
    end
  end
end
