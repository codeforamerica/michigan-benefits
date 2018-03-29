module Integrated
  class WhoIsDisabledController < MultipleMembersController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_disabled?
    end
  end
end
