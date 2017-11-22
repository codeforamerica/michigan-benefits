module Medicaid
  class IntroMaritalStatusIndicateSpouseController <
    Medicaid::MemberStepsController

    private

    def current_member
      @_current_member ||= member_from_querystring || first_married_member
    end

    def update_application
      member_from_form.update(step_params)
      update_spouse_of_other_member_if_present
    end

    def skip?
      single_member_household? ||
        current_application.nobody_married? ||
        current_member.spouse_id.present?
    end

    def first_married_member
      current_application.
        members.
        married.
        limit(1).
        first
    end

    def next_member
      current_member = member_from_form ||
        member_from_querystring ||
        first_married_member

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
        spouse.update!(spouse_id: step_params[:id])
      end
    end

    def member_from_form
      @member_from_form ||= current_application.
        members.
        where(id: step_params[:id]).
        first
    end
  end
end
