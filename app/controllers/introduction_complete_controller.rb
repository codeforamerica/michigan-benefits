# frozen_string_literal: true

class IntroductionCompleteController < StepsController
  def edit
    @step = step_class.new(first_name: current_app.applicant.first_name)
  end
end
