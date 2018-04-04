module Integrated
  class WhoIsPregnantController < MultipleMembersController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_pregnant?
    end
  end
end
