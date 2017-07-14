# frozen_string_literal: true

class IntroductionHomeAddressController < StandardSimpleStepController
  private

  def skip?
    current_app.mailing_address_same_as_home_address
  end
end
