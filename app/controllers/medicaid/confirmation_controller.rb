# frozen_string_literal: true

module Medicaid
  class ConfirmationController < StandardStepsController
    include MedicaidFlow
  end
end
