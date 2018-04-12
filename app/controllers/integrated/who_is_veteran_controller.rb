module Integrated
  class WhoIsVeteranController < MultipleMembersPerPageController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_veteran?
    end
  end
end
