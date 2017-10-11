class AddressController < StandardStepsController
  include SnapFlow

  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_application.update!(snap_application_update_params)
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

  def address_attributes
    address.attributes.merge(current_application.attributes)
  end

  def step_params
    super.merge(state: "MI", county: "Genesee")
  end
end
