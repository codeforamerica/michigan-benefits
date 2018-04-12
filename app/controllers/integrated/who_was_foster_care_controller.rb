module Integrated
  class WhoWasFosterCareController < MultipleMembersPerPageController
    def self.skip?(application)
      return true if application.single_member_household?
      !application.navigator.anyone_foster_care_at_18?
    end

    def members_to_update
      current_application.members.select do |member|
        member.birthday.nil? || (member.age >= 18 && member.age <= 26)
      end
    end
  end
end
