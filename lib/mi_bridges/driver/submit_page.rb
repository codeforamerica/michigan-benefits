
module MiBridges
  class Driver
    class SubmitPage < BasePage
      def self.title
        "Before You Submit the Application"
      end

      def setup; end

      def fill_in_required_fields; end

      def continue
        unless ENV["RUN_MI_BRIDGES_TEST"] == "true"
          close
        end
      end
    end
  end
end
