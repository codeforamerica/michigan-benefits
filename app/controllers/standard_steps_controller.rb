# frozen_string_literal: true

class StandardStepsController < StepsController
  def edit
    @step = step_class.new(existing_attributes.slice(*step_attrs))

    before_rendering_edit_hook
  end

  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_snap_application.update!(step_params)
      after_successful_update_hook
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  # This is an intentional noop
  def after_successful_update_hook; end

  # This is an intentional noop
  def before_rendering_edit_hook; end

  def existing_attributes
    HashWithIndifferentAccess.new(current_snap_application&.attributes)
  end
end
