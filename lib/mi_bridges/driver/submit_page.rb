
module MiBridges
  class Driver
    class SubmitPage < BasePage
      def self.title
        "Before You Submit the Application"
      end

      def setup; end

      def fill_in_required_fields; end

      def continue
        close unless ENV["PRE_DEPLOY_TEST"] == "true"
      end
    end
  end
end
