# NOTE: a custom job is not needed for delivering mail; just use e.g. AccountMailer.welcome_email(account).deliver_later
class ExampleJob < ActiveJob::Base
  queue_as :default

  def perform(account_id)
    # If using thread-based workers (Sucker Punch), you'll need to acquire a DB connection manually.
    ActiveRecord::Base.connection_pool.with_connection do
      account = Account.find account_id
      account.update! awesome: true
    end
  end
end
