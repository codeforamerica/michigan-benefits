require "rails_helper"

RSpec.describe ApplicationMailer do
  describe ".snap_application_notification" do
    it "sets the correct headers" do
      with_modified_env EMAIL_DOMAIN: "example.com" do
        email = ApplicationMailer.snap_application_notification(
          file_name: "#{Rails.root}/spec/fixtures/image.jpg",
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
  end

  describe ".office_application_notification" do
    context "office_location not present" do
      it "sets the correct headers" do
        with_modified_env EMAIL_DOMAIN: "example.com" do
          email = ApplicationMailer.office_application_notification(
            file_name: "#{Rails.root}/spec/fixtures/image.jpg",
            recipient_email: "user@example.com",
          )
          from_header = email.header.select do |header|
            header.name == "From"
          end.first.value

          expect(from_header).to eq %("Michigan Benefits" <hello@example.com>)
          expect(email.from).to eq(["hello@example.com"])
          expect(email.to).to eq(["user@example.com"])
          expect(email.subject).to eq(
            "A new 1171 from the Digital Assister has been submitted!",
          )
          expect(email.body.encoded).not_to include(
            "by a client in your office lobby",
          )
        end
      end
    end

    context "office_location present" do
      it "sets the correct values" do
        with_modified_env EMAIL_DOMAIN: "example.com" do
          email = ApplicationMailer.office_application_notification(
            file_name: "#{Rails.root}/spec/fixtures/image.jpg",
            recipient_email: "user@example.com",
            office_location: "union",
          )
          from_header = email.header.select do |header|
            header.name == "From"
          end.first.value

          expect(from_header).to eq %("Michigan Benefits" <hello@example.com>)
          expect(email.from).to eq(["hello@example.com"])
          expect(email.to).to eq(["user@example.com"])
          expect(email.subject).to eq(
            "A new 1171 from someone in the lobby has been submitted!",
          )
          expect(email.body.encoded).to include(
            "Union",
          )
          expect(email.body.encoded).to include(
            "by a client in your office lobby",
          )
        end
      end
    end
  end
end
