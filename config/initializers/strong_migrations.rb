StrongMigrations.start_after = 20171005165616
StrongMigrations.auto_analyze = true

ActiveRecord::Base.dump_schema_after_migration =
  Rails.env.development? && `git status db/migrate/ --porcelain`.present?
