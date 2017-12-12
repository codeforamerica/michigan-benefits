module MiBridges
  class Driver
    class FillInAndClickNextPage < BasePage
      def setup; end

      def continue
        click_on "Next"
      end
    end
  end
end
