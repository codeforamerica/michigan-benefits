# frozen_string_literal: true

module Medicaid
  class ConfirmationController < MedicaidStepsController
    def previous_path(*_args)
      nil
    end
  end
end
