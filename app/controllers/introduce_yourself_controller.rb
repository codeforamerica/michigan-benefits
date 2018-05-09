class IntroduceYourselfController < SnapStepsController
  skip_before_action :ensure_application_present

  def update
    @step = step_class.new(step_params)

    if @step.valid?
      app = current_or_new_snap_application
      app.update!(office_page: step_params[:office_page])
      set_current_application(app)
      member.update!(member_update_params)
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def existing_attributes
    HashWithIndifferentAccess.new(member.attributes).
      merge(office_page_params)
  end

  def member_update_params
    step_params.except(:office_page)
  end

  def member
    current_or_new_snap_application.members.first ||
      current_or_new_snap_application.members.new
  end

  def current_or_new_snap_application
    current_application || SnapApplication.new
  end

  def office_page_params
    { office_page: params[:office_page] }
  end
end
