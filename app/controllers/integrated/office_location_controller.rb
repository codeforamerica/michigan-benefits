module Integrated
  class OfficeLocationController < FormsController
    def self.custom_skip_rule_set(application)
      application.office_page.present?
    end

    def update_models
      current_application.update!(params_for(:application))
    end

    private

    def existing_attributes
      HashWithIndifferentAccess.new(current_application.attributes)
    end
  end
end
