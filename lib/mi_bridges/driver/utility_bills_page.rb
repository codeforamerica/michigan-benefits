module MiBridges
  class Driver
    class UtilityBillsPage < BasePage
      def self.title
        "Utility Bills"
      end

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
        "star#{first_name_section(primary_member)}sUtilityBills"
      end

      def check_heat
        check_in_section(
          section_name,
          condition: utility_heat?,
          for_label: "Heat(gas,electric, propane,wood,etc)",
        )
      end

      def check_cooling
        check_in_section(
          section_name,
          condition: utility_cooling?,
          for_label: "Cooling (including room air conditioner)",
        )
      end

      def check_electricity
        check_in_section(
          section_name,
          condition: utility_electrity?,
          for_label: "Electricity(non heat)",
        )
      end

      def check_water_sewer
        check_in_section(
          section_name,
          condition: utility_water_sewer?,
          for_label: "Water/Sewer",
        )
      end

      def check_trash
        check_in_section(
          section_name,
          condition: utility_trash?,
          for_label: "Garbage/trash pick up",
        )
      end

      def check_phone
        check_in_section(
          section_name,
          condition: utility_phone?,
          for_label: "Telephone",
        )
      end

      def check_none
        check_in_section(
          section_name,
          condition: nothing_checked?,
          for_label: "None",
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
