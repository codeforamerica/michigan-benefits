module Integrated
  class WhoHasMedicalBillsController < MultipleMembersController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_medical_bills?
    end
  end
end
