class LoggerFactory
  def self.create(level: Logger::INFO, output:)
    logger = ActiveSupport::Logger.new(output)
    logger.formatter = Rails.application.config.log_formatter
    logger.level = level
    ActiveSupport::TaggedLogging.new(logger)
  end
end
