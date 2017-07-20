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
      current_app.transaction do
        current_app.update! marital_status: @step.marital_status
        current_app.applicant.update! sex: @step.sex, ssn: @step.ssn
      end

      redirect_to(next_path)
    else
      render :edit
    end
  end
end
