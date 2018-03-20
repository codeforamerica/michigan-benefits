module Integrated
  class ShareFoodCostsWithHouseholdController < FormsController
    def self.skip?(application)
      return true if application.unstable_housing?
      return true if application.food_applying_members.count <= 2
    end

    def update_models
      current_application.navigator.update(navigator_params)
    end

    private

    def existing_attributes
      HashWithIndifferentAccess.new(
        current_application.navigator.attributes,
      )
    end
  end
end
