# frozen_string_literal: true

class HouseholdPersonalDetailsController < StepsController
  def edit
    applicant_attributes = current_app.applicant.attributes.slice('sex', 'ssn')

    attributes = {
      marital_status: current_app.marital_status
    }.merge(applicant_attributes)

    @step = step_class.new(attributes)
  end

  def update
    @step = step_class.new(step_params)

    if @step.valid?
      update_app_and_applicant
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def update_app_and_applicant
    current_app.transaction do
      current_app.update!(marital_status: @step.marital_status)
      current_app.applicant.update!(sex: @step.sex, ssn: @step.ssn)
    end
  end
end
