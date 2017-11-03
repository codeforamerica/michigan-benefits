module Medicaid
  class InsuranceCurrentTypeController < Medicaid::MemberStepsController
    def update
      @step = step_class.new(step_params)

      if @step.valid?
        current_member.update(step_params)
        redirect_to(next_path)
      else
        render :edit
      end
    end

    def current_member
      @_current_member ||= super || first_insurance_holder
    end

    private

    def first_insurance_holder
      current_application.
        members.
        insured.
        limit(1).
        first
    end

    def next_member
      return if current_member.nil?

      current_application.
        members.
        insured.
        after(current_member).
        limit(1).
        first
    end

    def skip?
      current_application.nobody_insured?
    end
  end
end
