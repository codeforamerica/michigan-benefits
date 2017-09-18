desc "Queues faxes for signed, unfaxed applicants"
task queue_faxes: :environment do
  ExportFactory.export_unfaxed_snap_applications
end
