class SubmitApplicationViaMiBridgesJob < ApplicationJob
  def perform(export:)
    export.execute do |snap_application, logger|
      MiBridges::Driver.new(logger: logger,
                            snap_application: snap_application).run
      logger.info("Exported via MiBridges successfully")
    end
  end
end
