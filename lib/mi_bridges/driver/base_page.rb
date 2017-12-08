module MiBridges
  class Driver
    class BasePage
      INSTANTIATION_LIMIT = 5

      include Capybara::DSL

      @@run_counts = {}

      def initialize(snap_application, logger: nil)
        @logger = logger
        log("filling out page")
        @snap_application = snap_application
        return if skip_infinite_loop_check?
        check_for_infinite_looping
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
        selector = selector_for_radio("No one")

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

      attr_reader :snap_application, :logger

      def log(description, *text)
        if logger.present?
          logger.tagged(self.class.to_s) do
            logger.debug("#{description.upcase}: #{text.join(', ')}")
          end
        end
      end

      def skip_infinite_loop_check?
        self.class.instance_methods(false).include?(:skip_infinite_loop_check)
      end

      def check_for_infinite_looping
        @@run_counts[self.class.to_s] ||= 0
        if @@run_counts[self.class.to_s] >= INSTANTIATION_LIMIT
          raise MiBridges::Errors::TooManyAttempts.new(self.class.to_s)
        else
          @@run_counts[self.class.to_s] += 1
        end
      end

      def first_name_section(member)
        member.mi_bridges_formatted_name.gsub(/[^0-9A-Za-z]/, "")
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
