module Integrated
  class PropertyController < FormsController
    def self.skip_rule_sets(application)
      super << SkipRules.must_be_applying_for_food_assistance(application)
    end

    def update_models
      selected_types = params_for(:application).fetch(:properties, {}).
        reject(&:empty?)

      current_application.update!(properties: selected_types)
    end

    def existing_attributes
      HashWithIndifferentAccess.new(current_application.attributes)
    end
  end
end
