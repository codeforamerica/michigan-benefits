# frozen_string_literal: true

module MiBridges
  class Driver
    class MedicalBillsPage < BasePage
      TITLE = "Medical Bills"

      delegate(
        :medical_expenses,
        :primary_member,
        to: :snap_application,
      )

      def setup; end

      def fill_in_required_fields
        check_health_insurance
        check_prescriptions
        check_dental
        check_in_home_care
        check_hospital_bills
      end

      def continue
        click_on "Next"
      end

      private

      def check_health_insurance
        check_in_section(
          "#{first_name_section(primary_member)}sMedicalBills",
          condition: medical_expenses.include?("health_insurance"),
          for_label: "Health/hospitalization insurance premiums",
        )
      end

      def check_prescriptions
        check_in_section(
          "#{first_name_section(primary_member)}sMedicalBills",
          condition: medical_expenses.include?("prescriptions"),
          for_label: "Prescription drugs and over-the-counter medication",
        )
      end

      def check_dental
        check_in_section(
          "#{first_name_section(primary_member)}sMedicalBills",
          condition: medical_expenses.include?("dental"),
          for_label: "Medical, dental and vision services",
        )
      end

      def check_in_home_care
        check_in_section(
          "#{first_name_section(primary_member)}sMedicalBills",
          condition: medical_expenses.include?("in_home_care"),
          for_label: "Personal care services provided in home",
        )
      end

      def check_hospital_bills
        check_in_section(
          "#{first_name_section(primary_member)}sMedicalBills",
          condition: medical_expenses.include?("hospital_bills"),
          for_label: "Inpatient hospitalization/nursing care",
        )
      end
    end
  end
end
