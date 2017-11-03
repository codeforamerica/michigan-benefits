module MiBridges
  class Driver
    class PregnancyInformationPage < BasePage
      def self.title
        "Pregnancy Information"
      end

      delegate :members, to: :snap_application

      def setup; end

      def fill_in_required_fields
        if no_one_pregnant?
          check_no_one_in_section "starPregnancyAllPrograms"
        else
          members.each do |member|
            check_in_section(
              "starPregnancyAllPrograms",
              member.new_mom?,
              first_name_section(member),
            )
          end
        end
      end

      def continue
        click_on "Next"
      end

      private

      def no_one_pregnant?
        members.none?(&:new_mom?)
      end
    end
  end
end
