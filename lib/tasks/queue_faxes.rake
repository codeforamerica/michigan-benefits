desc "Queues faxes for signed, unfaxed applicants"
task queue_faxes: :environment do
  Enqueuer.new.enqueue_faxes
end
