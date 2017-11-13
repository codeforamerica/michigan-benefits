module Medicaid
  class IntroCitizenController < MedicaidStepsController
    private

    def update_application
      super

      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      { citizen: step_params[:everyone_a_citizen] }
    end
  end
end
