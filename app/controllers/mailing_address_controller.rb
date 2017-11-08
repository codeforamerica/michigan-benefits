class MailingAddressController < SnapStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_application.update!(
        snap_application_param => step_params[snap_application_param],
      )
      address.update(step_params.except(snap_application_param))
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def existing_attributes
    attributes = address.attributes.merge(current_application.attributes)
    HashWithIndifferentAccess.new(attributes)
  end

  def address
    current_application.addresses.where(mailing: true).first ||
      current_application.addresses.new(mailing: true)
  end

  def snap_application_param
    :mailing_address_same_as_residential_address
  end

  def step_params
    super.merge(state: "MI", county: "Genesee")
  end
end
