# frozen_string_literal: true

module MiBridges
  class Driver
    class OtherTypesOfIncomePage < BasePage
      TITLE = "Other Types of Income"

      def setup; end

      def fill_in_required_fields
        check_unemployment
        check_workers_compensation
        check_pension_or_retirement
        check_other_income
      end

      def continue
        click_on "Next"
      end

      private

      def check_unemployment
        check_in_section(
          section_name,
          condition: additional_income?("unemployment_insurance"),
          for_label: "Unemployment Benefits",
        )
      end

      def check_workers_compensation
        check_in_section(
          section_name,
          condition: additional_income?("workers_compensation"),
          for_label: "Workers Compensation",
        )
      end

      def check_pension_or_retirement
        check_in_section(
          section_name,
          condition: additional_income?("pension"),
          for_label: "Pension or Retirement",
        )
      end

      def check_other_income
        check_in_section(
          section_name,
          condition: additional_income?("other"),
          for_label: "Other Income",
        )
      end

      def section_name
        "star#{first_name_of_primary_member}sIncomeInformation"
      end

      def first_name_of_primary_member
        first_name_section(primary_member).capitalize
      end

      def additional_income?(source)
        additional_income.include?(source)
      end
    end
  end
end
