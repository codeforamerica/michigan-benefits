module MiBridges
  class Driver
    class SummaryPage < ClickNextPage
      def self.title
        /Summary/
      end

      def skip_infinite_loop_check; end
    end
  end
end
