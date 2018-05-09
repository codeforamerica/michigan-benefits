require "rails_helper"

RSpec.describe MedicaidApplication do
  describe "common benefit application" do
    let(:subject) do
      create(:medicaid_application)
    end

    it_should_behave_like "common benefit application"
  end

  describe "scopes" do
    describe ".signed" do
      it "returns applications that have been signed" do
        signed_application = create(:medicaid_application, signed_at: Time.now)
        create(:medicaid_application, signed_at: nil)

        signed_applications = MedicaidApplication.signed
        expect(signed_applications.count).to eq(1)
        expect(signed_applications.first).to eq(signed_application)
      end
    end
  end

  describe "#members" do
    it "returns them created_at ascending order" do
      old_member = build(:member, created_at: 1.year.ago)
      new_member = build(:member, created_at: 1.day.ago)
      medicaid_app = create(
        :medicaid_application,
        members: [old_member, new_member],
      )

      expect(medicaid_app.members).to eq([old_member, new_member])

      old_member.touch

      expect(medicaid_app.reload.members).to eq([old_member, new_member])
    end
  end

  describe "#residential_address" do
    context "residential address not present" do
      it "returns NullAddress" do
        app = create(:medicaid_application)
        create(:mailing_address, benefit_application: app)

        expect(app.residential_address).to be_a NullAddress
      end

      context "residential address present" do
        it "returns residential address" do
          app = create(:medicaid_application)
          create(:mailing_address, benefit_application: app)
          residential_address = create(
            :residential_address,
            benefit_application: app,
          )

          expect(app.residential_address).to eq residential_address
        end
      end
    end
  end

  describe "#mailing_address" do
    context "mailing address exists" do
      it "returns mailing address" do
        app = create(:medicaid_application)
        mailing_address = create(:mailing_address, benefit_application: app)

        expect(app.mailing_address).to eq(mailing_address)
      end
    end

    context "mailing address does not exist" do
      it "returns NullAddress" do
        app = create(:medicaid_application)
        create(:residential_address, benefit_application: app)

        expect(app.mailing_address.class).to eq(NullAddress)
      end
    end
  end

  describe "#no_expenses?" do
    it "returns false if anyone is self employed" do
      app = create(
        :medicaid_application,
        anyone_self_employed: true,
        anyone_pay_child_support_alimony_arrears: false,
        anyone_pay_student_loan_interest: false,
      )

      expect(app.no_expenses?).to eq(false)
    end

    it "returns false if anyone pays child support" do
      app = create(
        :medicaid_application,
        anyone_self_employed: false,
        anyone_pay_child_support_alimony_arrears: true,
        anyone_pay_student_loan_interest: false,
      )

      expect(app.no_expenses?).to eq(false)
    end

    it "returns false if anyone pays student loan interest" do
      app = create(
        :medicaid_application,
        anyone_employed: false,
        anyone_pay_child_support_alimony_arrears: false,
        anyone_pay_student_loan_interest: true,
      )

      expect(app.no_expenses?).to eq(false)
    end

    it "returns true if no expenses" do
      app = create(
        :medicaid_application,
        anyone_self_employed: false,
        anyone_pay_child_support_alimony_arrears: false,
        anyone_pay_student_loan_interest: false,
      )

      expect(app.no_expenses?).to eq(true)
    end
  end

  describe "#members_count" do
    it "returns the count of associated members" do
      app = create(
        :medicaid_application,
        members: build_list(:member, 5),
      )

      expect(app.members_count).to eq 5
    end
  end

  describe "#office_location" do
    context "when selected office location clio or union" do
      it "returns selected office location" do
        app1 = create(:medicaid_application,
          selected_office_location: "clio",
          office_page: "foo")
        app2 = create(:medicaid_application,
          selected_office_location: "union",
          office_page: "foo")

        expect(app1.office_location).to eq("clio")
        expect(app2.office_location).to eq("union")
      end
    end

    context "when selected office location is not clio or union" do
      it "returns nil" do
        app = create(:medicaid_application, selected_office_location: "other")

        expect(app.office_location).to eq(nil)
      end
    end

    context "when selected office location not present" do
      it "returns office page" do
        app = create(:medicaid_application,
          selected_office_location: nil,
          office_page: "union")

        expect(app.office_location).to eq("union")
      end
    end
  end
end
