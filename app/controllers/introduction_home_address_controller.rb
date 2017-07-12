class IntroductionHomeAddressController < SimpleStepController
  def edit
    @step = step_class.new(
      current_app.attributes.slice(*step_attrs)
    )
  end

  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_app.update!(step_params)
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def skip?
    current_app.mailing_address_same_as_home_address
  end

  def step_attrs
    IntroductionHomeAddress.attributes
  end
end
