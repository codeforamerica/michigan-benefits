# frozen_string_literal: true

module MiBridges
  class Driver
    class GoogleSearchPage < BasePage
      def setup
        visit "https://www.google.com"
      end

      def fill_in_required_fields
        fill_in "lst-ib", with: "Michigan Bridges"
      end

      def continue
        click_on "Google Search"
      end
    end
  end
end
