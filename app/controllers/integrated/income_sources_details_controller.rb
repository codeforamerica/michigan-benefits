module Integrated
  class IncomeSourcesDetailsController < MemberPerPageController
    def self.custom_skip_rule_set(application)
      application.additional_incomes.none?
    end

    def edit
      @form = form_class.new(additional_incomes: current_member.additional_incomes, id: current_member.id)
    end

    def update_models
      ActiveRecord::Base.transaction do
        @form.additional_incomes.compact.each(&:save!)
      end
    end

    def assign_attributes_to_form
      @form = form_class.new(id: form_params[:id],
                             additional_incomes: current_member.additional_incomes,
                             valid_members: member_scope)

      @form.additional_incomes.map do |income|
        attrs = form_params.dig(:additional_incomes, income.to_param)
        if attrs.present?
          income.assign_attributes(attrs.slice(*form_attrs))
        end
      end
    end

    private

    def form_params
      params.fetch(:form, {}).permit(*form_attrs, additional_incomes: {})
    end

    def member_scope
      current_application.members.with_additional_income
    end
  end
end
