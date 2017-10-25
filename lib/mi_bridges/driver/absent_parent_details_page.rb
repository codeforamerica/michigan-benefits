module MiBridges
  class Driver
    class AbsentParentDetailsPage < BasePage
      def self.title
        "Absent Parent Details"
      end

      def setup; end

      def fill_in_required_fields
        indicate_parent_name_unknown
      end

      def continue
        click_on "Next"
      end

      private

      def indicate_parent_name_unknown
        click_id("nameUnknown")
      end
    end
  end
end
