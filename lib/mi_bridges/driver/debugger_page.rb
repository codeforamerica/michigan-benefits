module MiBridges
  class Driver
    class DebuggerPage < BasePage
      def setup; end

      def fill_in_required_fields; end

      def continue
        binding.pry if ENV["DEBUG_DRIVE"]
      end
    end
  end
end
