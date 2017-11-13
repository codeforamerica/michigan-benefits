module Medicaid
  class IncomeSelfEmploymentController < MedicaidStepsController
    private

    def update_application
      super

      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      { self_employed: step_params[:anyone_self_employed] }
    end
  end
end
