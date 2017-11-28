require "rails_helper"

RSpec.describe OfficeEmailApplicationJob do
  describe "#perform" do
    context "SNAP application" do
      it "sends an email with the correct content" do
        snap_application = create(:snap_application, :with_member)
        export = Export.create(
          benefit_application: snap_application,
          destination: :office_email,
        )
        job = OfficeEmailApplicationJob.new
        deliver_double = double(deliver: true)
        allow(ApplicationMailer).to receive(
          :office_snap_application_notification,
        ).and_return(deliver_double)

        job.perform(export: export)

        snap_application.reload
        expect(ApplicationMailer).
          to have_received(:office_snap_application_notification).
          with(
            hash_including(
              recipient_email: snap_application.receiving_office_email,
              office_location: snap_application.office_location,
            ),
          )
      end
    end

    context "Medicaid application" do
      it "sends an email with the correct content" do
        medicaid_application = create(:medicaid_application, :with_member)
        export = Export.create(
          benefit_application: medicaid_application,
          destination: :office_email,
        )
        job = OfficeEmailApplicationJob.new
        deliver_double = double(deliver: true)
        allow(ApplicationMailer).to receive(
          :office_medicaid_application_notification,
        ).and_return(deliver_double)

        job.perform(export: export)

        medicaid_application.reload
        expect(ApplicationMailer).
          to have_received(:office_medicaid_application_notification).
          with(
            hash_including(
              recipient_email: medicaid_application.receiving_office_email,
            ),
          )
      end
    end
  end
end
