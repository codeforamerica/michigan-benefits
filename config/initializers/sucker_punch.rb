
Rails.application.config.active_job.queue_adapter = :sucker_punch
SuckerPunch.exception_handler { |ex| Airbrake.notify(ex) }
