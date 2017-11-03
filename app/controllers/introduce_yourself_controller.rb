class IntroduceYourselfController < SnapStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      app = current_or_new_snap_application
      app.update!(office_location: step_params[:office_location])
      set_current_application(app)
      member.update!(member_update_params)
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def ensure_application_present
    true
  end

  def existing_attributes
    HashWithIndifferentAccess.new(member.attributes).
      merge(office_location_params)
  end

  def member_update_params
    step_params.except(:office_location)
  end

  def member
    current_or_new_snap_application.members.first ||
      current_or_new_snap_application.members.new
  end

  def current_or_new_snap_application
    current_application || SnapApplication.new
  end

  def office_location_params
    { office_location: params[:office_location] }
  end
end
