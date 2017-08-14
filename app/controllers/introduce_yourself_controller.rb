# frozen_string_literal: true

class IntroduceYourselfController < StandardStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      app = current_or_new_snap_application
      app.update!(snap_application_update_params)
      set_current_snap_application(app)
      member.update!(member_update_params)
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def existing_attributes
    HashWithIndifferentAccess.new(
      member.attributes.merge(
        birthday: current_or_new_snap_application.birthday,
      ),
    )
  end

  def snap_application_update_params
    { birthday: params[:birthday] }
  end

  def member_update_params
    step_params.except("birthday(1i)", "birthday(2i)", "birthday(3i)")
  end

  def member
    current_or_new_snap_application.members.first ||
      current_or_new_snap_application.members.new
  end

  def current_or_new_snap_application
    current_snap_application || SnapApplication.new
  end
end
