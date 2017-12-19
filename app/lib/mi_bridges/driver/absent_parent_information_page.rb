module MiBridges
  class Driver
    class AbsentParentInformationPage < FillInAndClickNextPage
      def self.title
        "Absent Parent Information"
      end

      def skip_infinite_loop_check; end

      def fill_in_required_fields
        if page.has_css?("#starCommonAbsentParent")
          check_no_one_for_common_absent_parent
        end
      end

      private

      def check_no_one_for_common_absent_parent
        click_id("NoOne_ABSENT")
      end
    end
  end
end
