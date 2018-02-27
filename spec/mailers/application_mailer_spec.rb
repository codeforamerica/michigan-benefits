require "rails_helper"

RSpec.describe ApplicationMailer do
  let(:application_pdf) { Tempfile.new }

  describe ".snap_application_notification" do
    it "sets the correct headers" do
      with_modified_env EMAIL_DOMAIN: "example.com" do
        email = ApplicationMailer.snap_application_notification(
          application_pdf: application_pdf,
          recipient_email: "user@example.com",
        )
        from_header = email.header.select do |header|
          header.name == "From"
        end.first.value

        expect(from_header).to eq %("Michigan Benefits" <hello@example.com>)
        expect(email.from).to eq(["hello@example.com"])
        expect(email.to).to eq(["user@example.com"])
        expect(email.subject).to eq("Your SNAP application")
      end
    end

    it "attaches the application PDF with correct name" do
      email = ApplicationMailer.snap_application_notification(
        application_pdf: application_pdf,
        recipient_email: "user@example.com",
      )
      attachment_filename = email.attachments.first.filename

      expect(email.attachments.count).to eq(1)
      expect(attachment_filename).to eq("snap_application.pdf")
    end
  end

  describe ".office_snap_application_notification" do
    context "office_location not present" do
      it "sets the correct headers" do
        time = Time.utc(2017, 12, 30, 10, 5, 0)
        Timecop.freeze(time) do
          with_modified_env EMAIL_DOMAIN: "example.com" do
            email = ApplicationMailer.office_snap_application_notification(
              application_pdf: application_pdf,
              recipient_email: "user@example.com",
              applicant_name: "Alice Algae",
            )
            from_header = email.header.select do |header|
              header.name == "From"
            end.first.value

            expect(from_header).to eq %("Michigan Benefits" <hello@example.com>)
            expect(email.from).to eq(["hello@example.com"])
            expect(email.to).to eq(["user@example.com"])
            expect(email.subject).to eq(
              "A new 1171 from Alice Algae (online) was submitted!",
            )
            expect(email.body.encoded).not_to include(
              "client in your office lobby",
            )
            expect(email.attachments[0].filename).to eq(
              "2017-12-30 Alice Algae 1171.pdf",
            )
          end
        end
      end
    end

    context "office_location present" do
      it "sets the correct values" do
        time = Time.utc(2008, 9, 1, 10, 5, 0)
        Timecop.freeze(time) do
          with_modified_env EMAIL_DOMAIN: "example.com" do
            email = ApplicationMailer.office_snap_application_notification(
              application_pdf: application_pdf,
              recipient_email: "user@example.com",
              office_location: "union",
              applicant_name: "Freddy Fungus",
            )

            from_header = email.header.select do |header|
              header.name == "From"
            end.first.value

            expect(from_header).to eq %("Michigan Benefits" <hello@example.com>)
            expect(email.from).to eq(["hello@example.com"])
            expect(email.to).to eq(["user@example.com"])
            expect(email.subject).to eq(
              "A new 1171 from Freddy Fungus (in the lobby) was submitted!",
            )
            expect(email.body.encoded).to include(
              "Union",
            )
            expect(email.body.encoded).to include(
              "client in your office lobby",
            )
            expect(email.attachments[0].filename).to eq(
              "2008-09-01 Freddy Fungus 1171.pdf",
            )
          end
        end
      end
    end
  end

  describe ".office_medicaid_application_notification" do
    it "sets the correct headers" do
      time = Time.utc(1999, 1, 1, 10, 5, 0)
      Timecop.freeze(time) do
        with_modified_env EMAIL_DOMAIN: "example.com" do
          email = ApplicationMailer.office_medicaid_application_notification(
            application_pdf: application_pdf,
            recipient_email: "user@example.com",
            applicant_name: "Larry Lichen",
          )

          from_header = email.header.select do |header|
            header.name == "From"
          end.first.value

          expect(from_header).to eq %("Michigan Benefits" <hello@example.com>)
          expect(email.from).to eq(["hello@example.com"])
          expect(email.to).to eq(["user@example.com"])
          expect(email.subject).to eq(
            "A new 1426 from Larry Lichen was submitted!",
          )
          expect(email.attachments[0].filename).to eq(
            "1999-01-01 Larry Lichen 1426.pdf",
          )
        end
      end
    end
  end

  describe ".office_integrated_application_notification" do
    it "sets the correct headers" do
      time = Time.utc(1999, 1, 1, 10, 5, 0)
      Timecop.freeze(time) do
        with_modified_env EMAIL_DOMAIN: "example.com" do
          email = ApplicationMailer.office_integrated_application_notification(
            application_pdf: application_pdf,
            recipient_email: "user@example.com",
            applicant_name: "Larry Lichen",
          )

          from_header = email.header.select do |header|
            header.name == "From"
          end.first.value

          expect(from_header).to eq %("Michigan Benefits" <hello@example.com>)
          expect(email.from).to eq(["hello@example.com"])
          expect(email.to).to eq(["user@example.com"])
          expect(email.subject).to eq(
            "A new 1171 from Larry Lichen was submitted!",
          )
          expect(email.attachments[0].filename).to eq(
            "1999-01-01 Larry Lichen 1171.pdf",
          )
        end
      end
    end
  end
end
