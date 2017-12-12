module MiBridges
  class Driver
    class HouseholdMemberQuestionsPage < FillInAndClickNextPage
      def self.title
        "Household Member Questions"
      end

      delegate(
        :anyone_disabled?,
        :primary_member,
        to: :snap_application,
      )

      def fill_in_required_fields
        check_blindness_or_disability
        check_drug_felonies
        check_probation_or_parole
        check_other_food_assistence_benefits
        check_ssi_benefit
        check_cash_benefit_from_mdhhs
        check_refugee_asylee_or_victim
      end

      private

      def check_blindness_or_disability
        check_in_section(
          "starBlindnessorDisability",
          condition: anyone_disabled?,
          for_label: primary_member.mi_bridges_formatted_name,
        )
      end

      def check_drug_felonies
        check_no_one_in_section "starDrugFelonies"
      end

      def check_probation_or_parole
        check_no_one_in_section "starProbationorParole"
      end

      def check_other_food_assistence_benefits
        check_no_one_in_section "starOtherFoodAssistanceBenefits"
      end

      def check_ssi_benefit
        check_in_section(
          "starSSIBenefit",
          condition: anyone_disabled?,
          for_label: primary_member.mi_bridges_formatted_name,
        )
      end

      def check_cash_benefit_from_mdhhs
        check_no_one_in_section "starCashBenefitfromMDHHS"
      end

      def check_refugee_asylee_or_victim
        check_no_one_in_section(
          "starRefugeeAsyleeorVictimofTraffickingInformation",
        )
      end
    end
  end
end
