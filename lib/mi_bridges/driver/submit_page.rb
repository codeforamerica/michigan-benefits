
module MiBridges
  class Driver
    class SubmitPage < DebuggerPage
      def setup
        check_page_title(
          "Before You Submit the Application",
        )
      end
    end
  end
end
