module Medicaid
  class HealthPregnancyController < MedicaidStepsController
    def edit
      super

      @step.members = current_application.members
    end

    private

    def update_application
      super

      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      elsif female_members.count == 1
        female_members.each do |member|
          member.update!(member_attrs)
        end
      end
    end

    def female_members
      current_application.members.select(&:female?)
    end

    def skip?
      all_males?
    end

    def all_males?
      current_application.members.all?(&:male?)
    end

    def member_attrs
      { new_mom: step_params[:anyone_new_mom] }
    end
  end
end
