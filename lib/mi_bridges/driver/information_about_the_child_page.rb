module MiBridges
  class Driver
    class InformationAboutTheChildPage < FillInAndClickNextPage
      def self.title
        "Information About the Child"
      end

      def fill_in_required_fields
        select "Single-Never Married", from: marital_status_question
      end

      private

      def marital_status_question
        "What was the marital status of the mother while pregnant with this" +
          " child?"
      end
    end
  end
end
