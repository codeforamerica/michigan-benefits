# frozen_string_literal: true

module Medicaid
  class IntroCaretakerMemberController < Medicaid::ManyMemberStepsController
    private

    def member_attrs
      %i[caretaker_or_parent]
    end

    def skip?
      single_member_household? ||
        current_application.nobody_caretaker_or_parent?
    end
  end
end
