# frozen_string_literal: true

class IntroductionHomeAddressController < StandardStepsController
  private

  def skip?
    current_app.mailing_address_same_as_home_address
  end
end
