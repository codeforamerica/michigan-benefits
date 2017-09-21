# frozen_string_literal: true

module MiBridges
  class Driver
    class BasePage
      include Capybara::DSL

      def initialize(snap_application, logger:)
        @logger = logger
        log("filling out page")
        @snap_application = snap_application
      end

      def fill_in(*args)
        log("fill in", args)
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

      def check_no_one_in_section(section)
        check_in_section(section)
      end

      def selector_for_radio(name)
        "label:contains('#{name}') input"
      end

      def next
        click_on "Next"
      end

      private

      attr_reader :snap_application, :logger

      def check_page_title(title)
        id = title.gsub(/[^0-9A-Za-z]/, "")
        page.find(:css, "##{id}")
      end

      def first_name_section(member)
        member.first_name_and_age.gsub(/[^0-9A-Za-z]/, "")
      end

      def log(description, *text)
        logger.tagged(self.class.to_s) do
          logger.debug("#{description.upcase}: #{text.join(', ')}")
        end
      end

      def fill_in_birthday_fields(birthday)
        month = padded(birthday.month)
        day = padded(birthday.day)
        year = birthday.year

        fill_in "monthgroupDateOfBirth", with: month
        fill_in "dategroupDateOfBirth", with: day
        fill_in "yeargroupDateOfBirth", with: year

        fill_in "monthconfirmGroupDateOfBirth", with: month
        fill_in "dateconfirmGroupDateOfBirth", with: day
        fill_in "yearconfirmGroupDateOfBirth", with: year
      end

      def padded(int)
        sprintf("%02d", int)
      end
    end
  end
end
