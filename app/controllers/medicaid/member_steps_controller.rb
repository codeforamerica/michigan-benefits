# frozen_string_literal: true

module Medicaid
  class MemberStepsController < MedicaidStepsController
    include PerMemberControllerMixin

    helper_method :current_member
  end
end
