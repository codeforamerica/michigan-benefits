module Medicaid
  class IncomeOtherIncomeTypeController < Medicaid::MemberStepsController
    def edit
      @step = step_class.new(
        array_to_checkboxes(current_member.other_income_types).
        merge(id: current_member.id),
      )
    end

    def update
      @step = step_class.new(
        update_params.merge(id: step_params[:id]),
      )

      if @step.valid?
        current_member.update(update_params)
        redirect_to(next_path)
      else
        render :edit
      end
    end

    def current_member
      @_current_member ||= super || first_other_income_member
    end

    private

    def update_params
      { other_income_types: checkboxes_to_array(step_params.except(:id)) }
    end

    def first_other_income_member
      current_application.
        members.
        other_income.
        limit(1).
        first
    end

    def next_member
      return if current_member.nil?

      current_application.
        members.
        other_income.
        after(current_member).
        limit(1).
        first
    end

    def skip?
      nobody_with_other_income?
    end

    def nobody_with_other_income?
      !current_application&.anyone_other_income?
    end

    def checkboxes_to_array(checkboxes)
      checkboxes.select { |_, value| value == "1" }.keys
    end
  end
end
