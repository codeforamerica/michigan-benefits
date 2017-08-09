# frozen_string_literal: true

class MailingAddressController < StandardStepsController
  private

  def step_params
    super.merge(state: "MI", county: "Genesee")
  end
end
