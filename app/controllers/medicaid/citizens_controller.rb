# frozen_string_literal: true

module Medicaid
  class CitizensController < Medicaid::ManyMemberStepsController
    private

    def skip?
      everyone_a_citizen?
    end

    def member_attrs
      %i[citizen]
    end

    def everyone_a_citizen?
      current_application.citizen?
    end
  end
end
