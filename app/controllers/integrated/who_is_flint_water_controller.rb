module Integrated
  class WhoIsFlintWaterController < MultipleMembersPerPageController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_flint_water?
    end
  end
end
