# Note on DB connection pooling:
# Heroku gives 20 DB connections. Each thread requires a connection.
# Each process has its own connection pool, so if you have 2 workers, don't have DB_POOL > 10.
# If you are using Sucker Punch for background jobs, keep some extra connections in the pool for worker threads to use.
workers Integer(ENV['PUMA_WORKERS'] || 1)
threads Integer(ENV['MIN_THREADS']  || 4), Integer(ENV['MAX_THREADS'] || 4)

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.connection_pool.disconnect!

  # worker specific setup
  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['pool'] = ENV['MAX_THREADS'] || 1
    ActiveRecord::Base.establish_connection(config)
  end
end
