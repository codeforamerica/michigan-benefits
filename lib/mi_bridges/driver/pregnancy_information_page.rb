module MiBridges
  class Driver
    class PregnancyInformationPage < FillInAndClickNextPage
      def self.title
        "Pregnancy Information"
      end

      delegate :members, to: :snap_application

      def fill_in_required_fields
        if no_one_pregnant?
          check_no_one_in_section "starPregnancyAllPrograms"
        else
          members.each do |member|
            if member.new_mom?
              check_in_section(
                "starPregnancyAllPrograms",
                condition: true,
                for_label: member.mi_bridges_formatted_name,
              )
            end
          end
        end
      end

      private

      def no_one_pregnant?
        members.none?(&:new_mom?)
      end
    end
  end
end
