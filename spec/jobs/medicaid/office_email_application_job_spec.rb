require "rails_helper"

RSpec.describe Medicaid::OfficeEmailApplicationJob do
  describe "#perform" do
    it "sends an email" do
      medicaid_application = create(:medicaid_application, :with_member)
      primary_member = medicaid_application.primary_member
      export = Export.create(
        benefit_application: medicaid_application,
        destination: :office_email,
      )
      job = Medicaid::OfficeEmailApplicationJob.new
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
            applicant_name: primary_member.display_name,
          ),
        )
    end
  end
end
