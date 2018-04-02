module Integrated
  class WhoWasFosterCareController < MultipleMembersController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_foster_care_at_18?
    end
  end
end
