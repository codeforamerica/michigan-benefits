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
        js_click_selector(id)
      end

      def js_click_selector(selector)
        page.execute_script %($("#{selector}").click())
      end

      def check_in_section(section, condition: false, for_label: "")
        selector = if condition
                     selector_for_radio(for_label)
                   else
                     selector_for_radio("No one")
                   end

        widget = "[aria-labelledby='#{section}']"
        js_click_selector("#{widget} #{selector}")
      end

      def selector_for_radio(name)
        "label:contains('#{name}') input"
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
