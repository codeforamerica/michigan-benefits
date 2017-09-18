# frozen_string_literal: true

module MiBridges
  class Driver
    class JobIncomeInformationPage < BasePage
      delegate :primary_member, to: :snap_application

      delegate(
        :employment_status,
        :first_name,
        to: :primary_member,
      )

      def setup
        check_page_title(
          "Job Income Information",
        )
      end

      def fill_in_required_fields
        check_fulltime_employment_status
        check_self_employment_status
        check_fap_program_benefits
      end

      def continue
        click_on "Next"
      end

      private

      def check_fulltime_employment_status
        check_in_section(
          "starCurrentorRecentJob",
          condition: employment_status == "employed",
          for_label: first_name,
        )
      end

      def check_self_employment_status
        check_in_section(
          "starSelfEmployment",
          condition: employment_status == "self_employed",
          for_label: first_name,
        )
      end

      def check_fap_program_benefits
        check_in_section "starInKindIncome"
        check_in_section "starRefusaltoWork"
      end
    end
  end
end
