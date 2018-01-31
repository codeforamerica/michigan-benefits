RSpec.shared_examples "common benefit application" do
  describe "#last_emailed_office_at" do
    it "returns time application was last successfully emailed to office" do
      completed_at_time = DateTime.new(2018, 1, 1, 1, 30)

      create(:export,
        :emailed_office,
        :succeeded,
        completed_at: completed_at_time - 1.day,
        benefit_application: subject)
      create(:export,
        :emailed_office,
        :succeeded,
        completed_at: completed_at_time,
        benefit_application: subject)

      create(:export,
        :emailed_client,
        :succeeded,
        completed_at: completed_at_time - 1.day,
        benefit_application: subject)
      create(:export,
        :emailed_office,
        :failed,
        completed_at: completed_at_time - 1.day,
        benefit_application: subject)

      expect(subject.last_emailed_office_at).to eq(completed_at_time)
    end
  end

  describe "#signed_at_est" do
    context "signed_at present" do
      it "returns the UTC time in EST" do
        # September 1, 2008 10:05:00 AM UTC
        time = Time.utc(2008, 9, 1, 10, 5, 0)
        subject.update(signed_at: time)

        Timecop.freeze(time) do
          expect(subject.signed_at_est).to eq(
            "09/01/2008 at 06:05AM EDT",
          )
        end
      end

      it "returns the UTC time in EST with custom format" do
        # September 1, 2008 10:05:00 AM UTC
        time = Time.utc(2008, 9, 1, 10, 5, 0)
        subject.update(signed_at: time)

        Timecop.freeze(time) do
          expect(subject.signed_at_est("%m/%d/%Y")).to eq("09/01/2008")
        end
      end
    end

    context "signed_at not present" do
      it "returns nil" do
        subject.update(signed_at: nil)

        expect(subject.signed_at_est).to eq(nil)
      end
    end
  end

  describe "#primary_member" do
    context "when at least one member is present" do
      it "returns the member with the lowest id" do
        members = build_list(:member, 3)
        subject.update(members: members)

        expect(subject.primary_member).to eq(members.first)
      end
    end

    context "when no members are present" do
      it "returns NullMember" do
        subject.update(members: [])

        expect(subject.primary_member).to be_a(NullMember)
      end
    end
  end

  describe "#non_applicant_members" do
    context "when one member is present" do
      it "returns an empty array" do
        subject.update(members: [build(:member)])

        expect(subject.non_applicant_members).to eq([])
      end
    end

    context "when 2 members are present" do
      it "returns an array without the primary member" do
        members = build_list(:member, 2)
        subject.update(members: members)

        expect(subject.non_applicant_members).to match_array([members.second])
      end
    end
  end

  describe "#display_name" do
    it "returns the display name of the primary member" do
      member = double("member", display_name: "Octopus Cuttlefish")
      allow(subject).to receive(:primary_member) { member }
      expect(subject.display_name).to eq("Octopus Cuttlefish")
    end
  end

  describe "#mailing_address" do
    context "mailing address exists" do
      it "returns mailing address" do
        mailing_address = build(:mailing_address)
        subject.update(addresses: [mailing_address])

        expect(subject.mailing_address).to eq(mailing_address)
      end
    end

    context "mailing address does not exist" do
      it "returns NullAddress" do
        subject.update(addresses: [build(:residential_address)])

        expect(subject.mailing_address).to be_a(NullAddress)
      end
    end
  end

  describe "#unstable_housing?" do
    context "when stable_housing is true" do
      it "returns false" do
        subject.stable_housing = true

        expect(subject.unstable_housing?).to eq(false)
      end
    end

    context "when stable_housing is false" do
      it "returns true" do
        subject.stable_housing = false

        expect(subject.unstable_housing?).to eq(true)
      end
    end

    context "when stable_housing is nil" do
      it "returns false" do
        subject.stable_housing = nil

        expect(subject.unstable_housing?).to eq(false)
      end
    end
  end

  describe "#stable_housing?" do
    context "when stable_housing is true" do
      it "returns true" do
        subject.stable_housing = true

        expect(subject.stable_housing?).to eq(true)
      end
    end

    context "when stable_housing is false" do
      it "returns false" do
        subject.stable_housing = false

        expect(subject.stable_housing?).to eq(false)
      end
    end

    context "when stable_housing is nil" do
      it "returns true" do
        subject.stable_housing = nil

        expect(subject.stable_housing?).to eq(true)
      end
    end
  end
end
