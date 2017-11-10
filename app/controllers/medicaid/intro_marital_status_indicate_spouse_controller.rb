module Medicaid
  class IntroMaritalStatusIndicateSpouseController <
    Medicaid::MemberStepsController

    def current_member
      @_current_member ||= super || first_married_member
    end

    private

    def after_successful_update_hook
      current_member.update(step_params)
      update_spouse_of_other_member_if_present
    end

    def application_params
      {}
    end

    def skip?
      single_member_household? ||
        current_application.nobody_married?
    end

    def first_married_member
      current_application.
        members.
        married.
        limit(1).
        first
    end

    def next_member
      return if current_member.nil?

      current_application.
        members.
        married.
        after(current_member).
        limit(1).
        first
    end

    def update_spouse_of_other_member_if_present
      spouse = Member.where(id: step_params[:spouse_id]).first
      if spouse.present?
        spouse.update!(spouse_id: current_member.id)
      end
    end
  end
end
