desc "Queues faxes for signed, unfaxed applicants"
task queue_faxes: :environment do
  SnapApplication.enqueue_faxes
end
