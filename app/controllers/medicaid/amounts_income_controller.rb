module Medicaid
  class AmountsIncomeController < Medicaid::MemberStepsController
    def current_member
      @_current_member ||= super || first_member_with_income
    end

    def update
      @step = step_class.new(
        step_params.merge(member_id: current_member.id),
      )

      if @step.valid?
        current_member.update!(step_params)
        after_successful_update_hook
        redirect_to(next_path)
      else
        render :edit
      end
    end

    private

    def first_member_with_income
      current_application.
        members.
        receiving_income.
        limit(1).
        first
    end

    def next_member
      return if current_member.nil?

      current_application.
        members.
        receiving_income.
        after(current_member).
        limit(1).
        first
    end

    def employed_number_of_jobs
      current_application.primary_member.employed_number_of_jobs
    end

    def skip?
      no_one_with_income? || member_has_no_income?
    end

    def no_one_with_income?
      no_one_employed? &&
        no_one_self_employed? &&
        no_one_with_other_income?
    end

    def member_has_no_income?
      member_not_employed? &&
        member_not_self_employed? &&
        member_not_receiving_unemployment?
    end

    def no_one_employed?
      !current_application&.anyone_employed?
    end

    def no_one_self_employed?
      !current_application&.anyone_self_employed?
    end

    def no_one_with_other_income?
      !current_application&.anyone_other_income?
    end

    def member_not_employed?
      !current_member&.employed?
    end

    def member_not_self_employed?
      !current_member&.self_employed?
    end

    def member_not_receiving_unemployment?
      !current_member&.unemployment_income?
    end
  end
end
