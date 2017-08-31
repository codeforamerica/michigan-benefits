# frozen_string_literal: true

class StandardStepsController < StepsController
  def edit
    @step = step_class.new(existing_attributes.slice(*step_attrs))

    before_rendering_edit
  end

  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_snap_application.update!(step_params)
      after_successful_update
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  # Hook for step controllers to add behavior after successful update. This is
  # intentionally a no-op in the StandardStepsController.
  def after_successful_update; end

  # Hook for step controllers to add behavior after the step is
  # instantiated but before rendering the edit screen. This is
  # intentionally a no-op in the StandardStepsController.
  def before_rendering_edit; end

  def existing_attributes
    HashWithIndifferentAccess.new(current_snap_application.attributes)
  end
end
