# Place idempotent, one off execution things here so they get auto-ran on deploy
namespace :one_offs do
  desc "runs all one_offs, remove things from here after they are deployed"
  task run_all: :environment do
    migrate_faxed_at_to_exports
  end

  def migrate_faxed_at_to_exports
    applications = SnapApplication.where.not(faxed_at: nil)
    applications.find_each do |application|
      recipient = FaxRecipient.new(snap_application: application)

      metadata = "Faxed to #{recipient.name} (#{recipient.number})"

      application.exports.create(destination: :fax, status: :succeeded,
                                 completed_at: application.faxed_at,
                                 metadata: metadata)

      application.update(faxed_at: nil)
    end
  end
end
