# frozen_string_literal: true

module Medicaid
  class ContactTextMessagesController < MedicaidStepsController
    private

    def step_class
      Medicaid::ContactTextMessages
    end
  end
end
