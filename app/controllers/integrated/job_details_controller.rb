module Integrated
  class JobDetailsController < MemberPerPageController
    def self.skip?(application)
      !application.anyone_employed?
    end

    def edit
      @form = form_class.new(employments: current_member.employments, id: current_member.id)
    end

    def assign_attributes_to_form
      @form = form_class.new(id: form_params[:id],
                             employments: current_member.employments,
                             valid_members: member_scope)

      @form.employments.map do |employment|
        attrs = form_params.dig(:employments, employment.to_param)
        if attrs.present?
          attrs[:pay_quantity] = attrs[:pay_quantity_hourly] || attrs[:pay_quantity_salary]
          employment.assign_attributes(attrs.slice(*employment_attrs))
        end
      end
    end

    def update_models
      ActiveRecord::Base.transaction do
        @form.employments.compact.each(&:save!)
      end
    end

    private

    def employment_attrs
      %i[
        employer_name
        hourly_or_salary
        payment_frequency
        pay_quantity
        hours_per_week
      ]
    end

    def form_params
      params.fetch(:form, {}).permit(*form_attrs, employments: {})
    end

    def member_scope
      current_application.members.employed
    end
  end
end
