module Integrated
  class WhoIsNotCitizenController < MultipleMembersController
    def self.skip?(application)
      return true if application.single_member_household?
      application.navigator.everyone_citizen?
    end
  end
end
