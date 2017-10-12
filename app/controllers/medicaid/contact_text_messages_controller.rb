# frozen_string_literal: true

module Medicaid
  class ContactTextMessagesController < StandardStepsController
    include MedicaidFlow

    private

    def step_class
      Medicaid::ContactTextMessages
    end
  end
end
