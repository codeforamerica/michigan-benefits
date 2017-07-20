class Doctor < CitizenScripts::Doctor
  def run_checks
    # Use built-in default checks, if still desired
    run_default_checks

    # Add a custom check
    check_pdftk
  end

  private

  def check_pdftk
    check(
      name: "pdftk installed",
      command: "which pdftk",
      remedy: "http://www.pdflabs.com/tools/pdftk-server/"
    )
  end

  def check_direnv_installed
    # no-op
  end

  def check_envrc_file_exists
    # no-op
  end

  def check_db_exists
    check \
      name: "Development database exists",
      command: "source .env && rails runner -e development 'ActiveRecord::Base.connection'",
      remedy: command("rake db:setup")

    check \
      name: "Test database exists",
      command: "source .env && rails runner -e test 'ActiveRecord::Base.connection'",
      remedy: command("rake db:setup")
  end

  def check_db_migrated
    check \
      name: "DB is migrated",
      command: "source .env && rails runner 'ActiveRecord::Migration.check_pending!'",
      remedy: command("rake db:migrate db:test:prepare")
  end

  def check_env_file_exists
    check \
      name: ".env file exists (for 'heroku local')",
      command: "stat .env",
      remedy: command("cp .env.sample .env")
  end
end
