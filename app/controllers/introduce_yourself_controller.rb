# frozen_string_literal: true

class IntroduceYourselfController < StandardStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      app = current_or_new_snap_application
      app.update!(step_params)
      set_current_snap_application(app)
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def existing_attributes
    HashWithIndifferentAccess.new(current_or_new_snap_application.attributes)
  end

  def current_or_new_snap_application
    current_snap_application || SnapApplication.new
  end
end
