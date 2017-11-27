Delayed::Worker.max_run_time =
  ENV.fetch("DELAYED_WORKER_MAX_RUN_TIME", "15").to_i.minutes
Delayed::Worker.max_attempts = ENV.fetch("DELAYED_WORKER_MAX_ATTEMPTS", "5")
