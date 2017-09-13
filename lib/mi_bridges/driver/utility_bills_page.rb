# frozen_string_literal: true

module MiBridges
  class Driver
    class UtilityBillsPage < BasePage
      delegate(
        :primary_member,
        :utility_cooling?,
        :utility_electrity?,
        :utility_heat?,
        :utility_phone?,
        :utility_trash?,
        :utility_water_sewer?,
        to: :snap_application,
      )

      delegate :first_name, to: :primary_member

      def setup; end

      def fill_in_required_fields
        check_heat
        check_cooling
        check_electricity
        check_water_sewer
        check_trash
        check_phone
        check_none
      end

      def continue
        click_on "Next"
      end

      private

      def section_name
        "star#{first_name.capitalize}sUtilityBills"
      end

      def check_heat
        check_in_section(
          section_name,
          condition: utility_heat?,
          for_name: "Heat(gas,electric, propane,wood,etc)",
        )
      end

      def check_cooling
        check_in_section(
          section_name,
          condition: utility_cooling?,
          for_name: "Cooling (including room air conditioner)",
        )
      end

      def check_electricity
        check_in_section(
          section_name,
          condition: utility_electrity?,
          for_name: "Electricity(non heat)",
        )
      end

      def check_water_sewer
        check_in_section(
          section_name,
          condition: utility_water_sewer?,
          for_name: "Water/Sewer",
        )
      end

      def check_trash
        check_in_section(
          section_name,
          condition: utility_trash?,
          for_name: "Garbage/trash pick up",
        )
      end

      def check_phone
        check_in_section(
          section_name,
          condition: utility_phone?,
          for_name: "Telephone",
        )
      end

      def check_none
        check_in_section(
          section_name,
          condition: nothing_checked?,
          for_name: "None",
        )
      end

      def nothing_checked?
        !utility_phone? &&
          !utility_trash? &&
          !utility_water_sewer? &&
          !utility_cooling? &&
          !utility_electrity? &&
          !utility_cooling?
      end
    end
  end
end
