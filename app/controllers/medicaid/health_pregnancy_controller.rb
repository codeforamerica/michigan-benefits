# frozen_string_literal: true

module Medicaid
  class HealthPregnancyController < MedicaidStepsController
    private

    def skip?
      all_males?
    end

    def all_males?
      current_application.members.all? do |member|
        member.sex == "male"
      end
    end
  end
end
