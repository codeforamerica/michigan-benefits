module MiBridges
  class Driver
    class DebuggerPage < BasePage
      def setup; end

      def fill_in_required_fields; end

      def continue
        # rubocop:disable Debugger
        binding.pry if ENV["DEBUG_DRIVE"]
        # rubocop:enable Debugger
      end
    end
  end
end
