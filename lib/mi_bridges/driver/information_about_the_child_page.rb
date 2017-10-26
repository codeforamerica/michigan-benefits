module MiBridges
  class Driver
    class InformationAboutTheChildPage < BasePage
      def self.title
        "Information About the Child"
      end

      def setup; end

      def fill_in_required_fields
        select "Single-Never Married", from: marital_status_question
      end

      def continue
        click_on "Next"
      end

      private

      def marital_status_question
        "What was the marital status of the mother while pregnant with this" +
          " child?"
      end
    end
  end
end
