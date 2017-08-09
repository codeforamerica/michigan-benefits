# frozen_string_literal: true

class ResidentialAddressController < StandardStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_snap_application.update!(unstable_housing: unstable_housing?)
      residential_address.update!(step_params.except(:unstable_housing))
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def snap_application_attributes
    HashWithIndifferentAccess.new(residential_address_attributes)
  end

  def residential_address_attributes
    residential_address.attributes.merge(unstable_housing: current_snap_application.unstable_housing)
  end

  def residential_address
    current_snap_application.addresses.where.not(mailing: true).first || current_snap_application.addresses.new(mailing: false)
  end

  def step_params
    super.merge(state: "MI", county: "Genesee")
  end

  def unstable_housing?
    step_params[:unstable_housing] == "1"
  end

  def skip?
    current_snap_application.mailing_address_same_as_residential_address?
  end
end
