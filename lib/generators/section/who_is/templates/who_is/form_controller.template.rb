module Integrated
  class WhoIs<%= model_name %>Controller < MultipleMembersController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_<%= model_method %>?
    end
  end
end
