module Medicaid
  class AmountsIncomeController < Medicaid::MemberStepsController
    def edit
      attribute_keys = Step::Attributes.new(step_attrs).to_sym

      @step = step_class.new(
        existing_attributes.
          slice(*attribute_keys).
          merge(employments: current_member.employments),
      )
    end

    private

    def current_member
      @_current_member ||= super || first_member_with_income
    end

    def update_application
      current_member.update!(step_params.slice(*member_params))

      @step.employments&.each do |employment|
        attrs = step_params[:employments][employment.first]
        Employment.
          find(employment.first).
          update!(attrs.permit(employment_attrs))
      end
    end

    def member_params
      %i[unemployment_income self_employed_monthly_income]
    end

    def employment_attrs
      %i[pay_quantity employer_name payment_frequency]
    end

    def step_params
      params.fetch(:step, {}).permit!
    end

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

    def skip?
      current_application.no_one_with_income? ||
        current_member.nil? ||
        current_member.not_receiving_income?
    end
  end
end
