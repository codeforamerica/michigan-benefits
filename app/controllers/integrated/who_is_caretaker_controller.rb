module Integrated
  class WhoIsCaretakerController < MultipleMembersController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_caretaker?
    end
  end
end
