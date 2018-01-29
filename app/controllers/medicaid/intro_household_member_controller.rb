module Medicaid
  class IntroHouseholdMemberController < MedicaidStepsController
    def update_application
      member.update!(step_params)
    end

    private

    def existing_attributes
      HashWithIndifferentAccess.new(member_attributes)
    end

    def member_attributes
      {
        first_name: member.first_name,
        last_name: member.last_name,
        sex: member.sex,
        birthday: member.birthday,
      }
    end

    def member
      @member ||= current_application.members.build
    end
  end
end
