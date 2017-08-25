# frozen_string_literal: true

module MiBridges
  class Driver
    class BasePage
      include Capybara::DSL

      def initialize(snap_application)
        log("filling out page", self.class.to_s) if logging?
        @snap_application = snap_application
      end

      def fill_in(*args)
        log("fill in", args) if logging?
        super(*args)
      end

      def setup
        raise NotImplementedError
      end

      def fill_in_required_fields
        raise NotImplementedError
      end

      def continue
        raise NotImplementedError
      end

      def close
        page.driver.browser.close
      end

      def click_id(id)
        id = "##{id}" unless id.include?("#")
        page.execute_script("$('#{id}').click()")
      end

      def next
        click_on "Next"
      end

      private

      attr_reader :snap_application

      def log(description, *text)
        puts "*** #{description.upcase}: #{text.join(', ')}"
      end

      def logging?
        ENV.fetch("DEBUG_DRIVE", "false") == "true"
      end
    end
  end
end
