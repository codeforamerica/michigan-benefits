# frozen_string_literal: true

class IntroduceYourselfController < StepsController
  def edit
    current_app = current_or_new_snap_application

    @step = step_class.new(
      HashWithIndifferentAccess.
        new(current_app.attributes).
        slice(*step_attrs),
    )
  end

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
end
