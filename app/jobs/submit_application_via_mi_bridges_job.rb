class SubmitApplicationViaMiBridgesJob < ApplicationJob
  def perform(export:)
    export.execute do |benefit_application, logger|
      MiBridges::Driver.new(
        logger: logger,
        snap_application: benefit_application,
      ).run
      logger.info("Exported via MI Bridges successfully")
    end
  end
end
