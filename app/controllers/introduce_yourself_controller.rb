# frozen_string_literal: true

class IntroduceYourselfController < StandardStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      app = current_or_new_snap_application
      app.save!
      set_current_snap_application(app)
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
    HashWithIndifferentAccess.new(member.attributes)
  end

  def member_update_params
    step_params
  end

  def member
    current_or_new_snap_application.members.first ||
      current_or_new_snap_application.members.new
  end

  def current_or_new_snap_application
    current_snap_application || SnapApplication.new
  end
end
