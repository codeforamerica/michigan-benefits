require "selenium-webdriver"

module Selenium
  module WebDriver
    module Remote
      class Bridge
        def execute(command, opts = {}, command_hash = nil)
          verb, path = commands(command) ||
            raise(ArgumentError, "unknown command: #{command.inspect}")
          path = path.dup
          path[":session_id"] = session_id if path.include?(":session_id")

          begin
            opts.each do |key, value|
              path[key.inspect] = escaper.escape(value.to_s)
            end
          rescue IndexError
            raise ArgumentError,
              "#{opts.inspect} invalid for #{command.inspect}"
          end

          WebDriver.logger.info("-> #{verb.to_s.upcase} #{path}")

          case ENV.fetch("DRIVER_SPEED", "fast").to_sym
          when :slow
            sleep 0.3
          when :medium
            sleep 0.1
          end

          http.call(verb, path, command_hash)
        end
      end
    end
  end
end
