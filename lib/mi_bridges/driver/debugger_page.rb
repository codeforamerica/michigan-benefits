module MiBridges
  class Driver
    class DebuggerPage < BasePage
      def setup; end

      def fill_in_required_fields; end

      def continue
        if ENV["DEBUG_DRIVE"]
          # rubocop:disable Debugger
          binding.pry
          # rubocop:enable Debugger
        end
      end
    end
  end
end
