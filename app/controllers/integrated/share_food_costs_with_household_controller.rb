module Integrated
  class ShareFoodCostsWithHouseholdController < FormsController
    def self.skip?(application)
      return true if application.unstable_housing?
      return true if application.food_applying_members.count <= 2
    end

    def update_models
      current_application.navigator.update(navigator_params)
      if navigator_params[:all_share_food_costs]
        current_application.food_applying_members.each do |member|
          member.update_attributes(buy_and_prepare_food_together: "yes")
        end
      end
    end

    private

    def existing_attributes
      HashWithIndifferentAccess.new(
        current_application.navigator.attributes,
      )
    end
  end
end
