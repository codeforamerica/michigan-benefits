module Medicaid
  class IntroCitizenController < MedicaidStepsController
    private

    def update_application
      super

      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      elsif step_params[:everyone_a_citizen] == "true"
        current_application.members.each do |member|
          member.update!(citizen: true)
        end
      end
    end

    def member_attrs
      { citizen: step_params[:everyone_a_citizen] }
    end
  end
end
