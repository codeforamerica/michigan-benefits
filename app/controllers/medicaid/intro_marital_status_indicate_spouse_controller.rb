module Medicaid
  class IntroMaritalStatusIndicateSpouseController <
    Medicaid::MemberStepsController
    helper_method :spouse_options

    def update
      @step = step_class.new(step_params)

      if @step.valid?
        current_member.update(step_params)
        update_spouse_of_other_member_if_present
        redirect_to(next_path)
      else
        render :edit
      end
    end

    def current_member
      @_current_member ||= super || first_married_member
    end

    def spouse_options
      current_application.members -
        [current_member] +
        [OtherSpouse.new]
    end

    private

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
