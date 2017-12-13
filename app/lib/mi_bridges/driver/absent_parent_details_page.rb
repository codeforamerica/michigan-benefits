module MiBridges
  class Driver
    class AbsentParentDetailsPage < FillInAndClickNextPage
      def self.title
        "Absent Parent Details"
      end

      def fill_in_required_fields
        indicate_parent_name_unknown
      end

      private

      def indicate_parent_name_unknown
        click_id("nameUnknown")
      end
    end
  end
end
