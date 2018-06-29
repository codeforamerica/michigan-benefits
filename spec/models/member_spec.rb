require "rails_helper"

RSpec.describe Member do
  describe "scopes" do
    describe ".filing_taxes" do
      it "returns members filing taxes as Single or Joint" do
        no_relationship = build(:member, tax_relationship: nil)
        dependent = build(:member, tax_relationship: "Dependent")
        filing1 = build(:member, tax_relationship: "Single")
        filing2 = build(:member, tax_relationship: "Joint")

        create(
          :snap_application,
          members: [no_relationship, dependent, filing1, filing2],
        )

        expect(Member.filing_taxes).to eq [filing1, filing2]
      end
    end

    describe ".dependents" do
      it "returns members that are dependents of primary applicant" do
        no_relationship = build(:member, tax_relationship: nil)
        dependent = build(:member, tax_relationship: "Dependent")
        filing1 = build(:member, tax_relationship: "Single")
        filing2 = build(:member, tax_relationship: "Joint")
        create(
          :snap_application,
          members: [no_relationship, dependent, filing1, filing2],
        )

        expect(Member.dependents).to eq [dependent]
      end
    end

    describe ".no_tax_relationship" do
      it "returns members NOT filing taxes with primary applicant" do
        no_relationship = build(:member, tax_relationship: nil)
        dependent = build(:member, tax_relationship: "Dependent")
        filing1 = build(:member, tax_relationship: "Single")
        filing2 = build(:member, tax_relationship: "Joint")
        create(
          :snap_application,
          members: [no_relationship, dependent, filing1, filing2],
        )

        expect(Member.no_tax_relationship).to eq [no_relationship]
      end
    end

    describe ".first_insurance_holder" do
      it "returns the first member that is insured" do
        first =
          build(:member, insured: false, requesting_health_insurance: true)
        second =
          build(:member, insured: true, requesting_health_insurance: false)
        joel = build(:member, insured: true, requesting_health_insurance: true)
        create(:snap_application, members: [first, second, joel])

        expect(Member.insured).to eq [joel]
      end
    end

    describe ".after" do
      it "returns the next member _after_ the provided member" do
        joel = build(:member)
        jessie = build(:member)
        christa = build(:member)
        create(:snap_application, members: [joel, jessie, christa])

        expect(Member.after(joel)).to eq [jessie, christa]
        expect(Member.after(jessie)).to eq [christa]
      end
    end

    describe ".employed_or_self_employed" do
      it "returns members where employed: true or self_employed: true" do
        christa = build(:member, employed: true)
        ben = build(:member, self_employed: true)
        luigi = build(:member)
        create(:medicaid_application, members: [christa, ben, luigi])

        expect(Member.employed_or_self_employed).to eq [christa, ben]
      end

      it "returns members where employment_status is employed or self_employed" do
        christa = build(:member, employment_status: "employed")
        ben = build(:member, employment_status: "self_employed")
        luigi = build(:member)
        create(:snap_application, members: [christa, ben, luigi])

        expect(Member.employed_or_self_employed).to eq [christa, ben]
      end
    end
  end

  describe "#not_receiving_income?" do
    it "is true by default" do
      expect(build(:member).not_receiving_income?).to be true
    end

    it "is false if employed?" do
      expect(build(:member, employed: true).not_receiving_income?).to be false
    end

    it "is false if self_employed?" do
      expect(build(:member, self_employed: true).not_receiving_income?).to be false
    end

    it "is false if employment_status is employed?" do
      expect(build(:member, employment_status: "employed").not_receiving_income?).to be false
    end

    it "is false if employment_status is self_employed?" do
      expect(build(:member, employment_status: "self_employed").not_receiving_income?).to be false
    end

    it "is false if other_income_types includes unemployment" do
      expect(build(:member, other_income_types: ["unemployment"]).not_receiving_income?).to be false
    end
  end

  describe "#female?" do
    it "is true if the sex is female" do
      expect(build(:member, sex: "female")).to be_female
    end

    it "is false if the sex is male" do
      expect(build(:member, sex: "male")).not_to be_female
    end
  end

  describe "#male?" do
    it "is true if the sex is male" do
      expect(build(:member, sex: "male")).to be_male
    end

    it "is false if the sex is female" do
      expect(build(:member, sex: "female")).not_to be_male
    end
  end

  describe "#monthly_income" do
    context "unemployed" do
      it "returns 0" do
        member = build(:member, employment_status: "not_employed")

        expect(member.monthly_income).to eq 0
      end
    end

    context "self employed" do
      it "returns monthly income" do
        member = build(
          :member,
          employment_status: "self_employed",
          self_employed_monthly_income: 100,
        )

        expect(member.monthly_income).to eq 100
      end
    end

    context "employed" do
      it "calls MonthlyIncomeCalculator to find monthly income" do
        member = build(
          :member,
          employment_status: "employed",
          employed_pay_quantity: 10,
          employed_pay_interval: "Hourly",
          employed_hours_per_week: 10,
        )
        calc_double = double(run: true)
        allow(MonthlyIncomeCalculator).to receive(:new).with(
          pay_interval: "Hourly",
          pay_quantity: 10,
          hours_per_week: 10,
        ).and_return(calc_double)

        member.monthly_income

        expect(calc_double).to have_received(:run)
      end
    end
  end

  describe "#spouse_options" do
    it "returns all other married members in the application" do
      primary_member = build(:member, married: true)
      married_member = build(:member, married: true)
      unmarried_member = build(:member, married: false)

      create(
        :medicaid_application,
        members: [primary_member, married_member, unmarried_member],
      )

      expect(primary_member.spouse_options.size).to eq 2
      expect(primary_member.spouse_options).to include married_member
      expect(primary_member.spouse_options).not_to include unmarried_member
    end
  end

  describe "#mi_bridges_formatted_name" do
    context "name is over 10 chars" do
      it "cuts name off at 10 chars" do
        time = Time.utc(2008, 9, 1, 10, 5, 0)
        Timecop.freeze(time) do
          member = build(
            :member,
            first_name: "JacquelineR",
            birthday: DateTime.parse("June 20, 1990"),
          )

          expect(member.mi_bridges_formatted_name).to eq "Jacqueline (18)"
        end
      end
    end

    context "name is shorter than 10 chars" do
      it "returns full first name and age" do
        time = Time.utc(2008, 9, 1, 10, 5, 0)
        Timecop.freeze(time) do
          member = build(
            :member,
            first_name: "Lala",
            birthday: DateTime.parse("June 20, 1990"),
          )

          expect(member.mi_bridges_formatted_name).to eq "Lala (18)"
        end
      end
    end
  end

  describe "#age" do
    it "returns the age today is before this year's birthday" do
      time = Time.utc(2008, 1, 1, 10, 5, 0)
      Timecop.freeze(time) do
        member = build(
          :member,
          first_name: "Lala",
          birthday: DateTime.parse("June 20, 1990"),
        )

        expect(member.age).to eq 17
      end
    end

    it "returns the age today is after this year's birthday" do
      time = Time.utc(2008, 9, 1, 10, 5, 0)
      Timecop.freeze(time) do
        member = build(
          :member,
          first_name: "Lala",
          birthday: DateTime.parse("June 20, 1990"),
        )

        expect(member.age).to eq 18
      end
    end
  end

  describe "#other_income_types" do
    it "accepts all valid choices" do
      member = Member.new
      member.other_income_types = [
        "alimony",
        "other",
        "pension",
        "retirement",
        "social_security",
        "unemployment",
      ]
      member.valid?
      expect(member.errors).to_not include(:other_income_types)
    end

    it "accepts empty choices" do
      member = Member.new
      member.other_income_types = []
      member.valid?
      expect(member.errors).to_not include(:other_income_types)
    end

    it "rejects invalid choices" do
      member = Member.new
      member.other_income_types = [
        "side_hustle",
      ]
      member.valid?
      expect(member.errors).to include(:other_income_types)
    end
  end

  describe "#display_name" do
    it "only generates the display name once" do
      member = build(:member)
      create(
        :medicaid_application,
        members: [member],
      )

      expect(member.display_name).to be(member.display_name)
    end

    context "I have a unique first and last name for my household" do
      it "combines first name and last name" do
        member_one = build(:member, first_name: "anne", last_name: "mcDog")
        member_two = build(:member, first_name: "sophie", last_name: "grey")
        create(
          :medicaid_application,
          members: [member_one, member_two],
        )

        expect(member_one.display_name).to eq("Anne McDog")
        expect(member_two.display_name).to eq("Sophie Grey")
      end
    end

    context "I have same first name but different last name than someone my household" do
      it "combines first name and last name" do
        member_one = build(:member, first_name: "anne", last_name: "mcDog")
        member_two = build(:member, first_name: "anne", last_name: "grey")
        create(
          :medicaid_application,
          members: [member_one, member_two],
        )

        expect(member_one.display_name).to eq("Anne McDog")
        expect(member_two.display_name).to eq("Anne Grey")
      end
    end

    context "I have same first and last name as someone in my household" do
      it "combines first name and last name, plus date of birth" do
        member_one = build(:member,
                           first_name: "anne",
                           last_name: "mcDog",
                           birthday: Date.new(1980, 1, 2))
        member_two = build(:member,
                           first_name: "Anne",
                           last_name: "McDog",
                           birthday: Date.new(1990, 3, 14))
        create(
          :medicaid_application,
          members: [member_one, member_two],
        )

        expect(member_one.display_name).to eq("Anne McDog (1/2/1980)")
        expect(member_two.display_name).to eq("Anne McDog (3/14/1990)")
      end
    end
  end

  describe "#display_name_or_you" do
    let(:app) do
      create(
        :medicaid_application,
        members: [
          build(:member,
            first_name: "anne",
            last_name: "mcDog",
            birthday: Date.new(1980, 1, 2)),
          build(:member,
            first_name: "Anne",
            last_name: "McDog",
            birthday: Date.new(1990, 3, 14)),
        ],
      )
    end

    context "member is primary" do
      it "returns 'you'" do
        expect(app.primary_member.display_name_or_you).to eq("you")
      end
    end
    context "member is not primary" do
      it "returns 'display_name'" do
        secondary = app.members.last
        expect(secondary.display_name_or_you).to eq(secondary.display_name)
      end
    end
  end

  describe "#modify_employments" do
    it "creates employment from employed_number_of_jobs" do
      member = build(:member, employed_number_of_jobs: 3)
      create(
        :medicaid_application,
        members: [member],
      )
      member.modify_employments

      expect(member.employments.count).to eq 3
    end

    it "creates records if number of jobs is greater than employments count" do
      application = create(:medicaid_application, :with_member)
      existing_employments = build_list(:employment, 2)
      member = application.members.first
      member.update(
        employed_number_of_jobs: 3,
        employments: existing_employments,
      )
      member.modify_employments

      expect(member.employments.count).to eq 3
      expect(member.employments[0..1]).to match_array(existing_employments)
    end

    it "destroys records if number of jobs is less than employments count" do
      application = create(:medicaid_application, :with_member)

      existing_employments = build_list(:employment, 4)
      member = application.members.first
      member.update(
        employed_number_of_jobs: 2,
        employments: existing_employments,
      )

      expect(Employment.count).to eq 4
      member.modify_employments
      member.reload
      expect(Employment.count).to eq 2
      expect(member.employments).to match_array(existing_employments[0..1])
    end
  end
end
