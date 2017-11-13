class DelayedJobWebLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    if in_delayed_job?(env) && env["warden"].authenticated?
      Rails.logger.tagged(env["warden"].user.email) do
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
