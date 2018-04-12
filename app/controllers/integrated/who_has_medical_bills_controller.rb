module Integrated
  class WhoHasMedicalBillsController < MultipleMembersPerPageController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_medical_bills?
    end
  end
end
