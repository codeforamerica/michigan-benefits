desc "Queues faxes for signed, unfaxed applicants"
task queue_faxes: :environment do
  Export.enqueue_faxes
end
