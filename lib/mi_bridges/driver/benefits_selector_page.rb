# frozen_string_literal: true

module MiBridges
  class Driver
    class BenefitsSelectorPage < BasePage
      def setup; end

      def fill_in_required_fields
        click_id(food_assistance_checkbox)
        click_id(no_dont_contact_my_energy_provider_radio)
      end

      def continue; end

      private

      def food_assistance_checkbox
        "#requestFoodShare"
      end

      def no_dont_contact_my_energy_provider_radio
        "#isAuthorized_N"
      end
    end
  end
end
