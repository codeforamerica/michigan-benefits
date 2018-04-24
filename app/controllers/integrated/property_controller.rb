module Integrated
  class PropertyController < FormsController
    def update_models
      selected_types = application_params.fetch(:properties, {}).
        reject{ |value| value.empty? }

      current_application.update!(properties: selected_types)
    end

    def existing_attributes
      HashWithIndifferentAccess.new(current_application.attributes)
    end
  end
end
