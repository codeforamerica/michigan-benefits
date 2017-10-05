# frozen_string_literal: true

module MiBridges
  class Driver
    module Services
      class FindTrackingNumber
        def initialize(page_html)
          @page_html = page_html
        end

        def run
          sentence_with_tracking_number.split(" ").last
        end

        private

        attr_reader :page_html

        def sentence_with_tracking_number
          /Your tracking number for this application is \w+/.match(page_html)[0]
        end
      end
    end
  end
end
