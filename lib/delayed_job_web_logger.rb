class DelayedJobWebLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    if in_delayed_job?(env) && env["warden"].authenticated?
      email = env["warden"].user.email
      path = env["REQUEST_PATH"]
      unless path.match?(/\.(css|js|png|poll)/)
        Rails.logger.info("delayed_job_web | #{email} requested #{path}")
      end
      Rails.logger.tagged(email) do
        @app.call(env)
      end
    else
      @app.call(env)
    end
  end

  private

  def in_delayed_job?(env)
    env["PATH_INFO"].match? %r{^/delayed_job}
  end
end
