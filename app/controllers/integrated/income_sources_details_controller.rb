module Integrated
  class IncomeSourcesDetailsController < MemberPerPageController
    def self.skip?(application)
      application.incomes.none?
    end

    def edit
      @form = form_class.new(incomes: current_member.incomes, id: current_member.id)
    end

    def update_models
      ActiveRecord::Base.transaction do
        @form.incomes.compact.each(&:save!)
      end
    end

    def assign_attributes_to_form
      @form = form_class.new(id: form_params[:id],
                             incomes: current_member.incomes,
                             valid_members: member_scope)

      @form.incomes.map do |income|
        attrs = form_params.dig(:incomes, income.to_param)
        if attrs.present?
          income.assign_attributes(attrs.slice(*form_attrs))
        end
      end
    end

    private

    def form_params
      params.fetch(:form, {}).permit(*form_attrs, incomes: {})
    end

    def member_scope
      current_application.members.with_additional_income
    end
  end
end
