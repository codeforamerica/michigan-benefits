desc "Queues faxes for signed, unfaxed applicants"
task :queue_faxes do
  SnapApplication.enqueue_faxes
end
