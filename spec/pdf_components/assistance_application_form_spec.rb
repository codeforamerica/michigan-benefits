require "rails_helper"

RSpec.describe AssistanceApplicationForm do
  describe "pdf component" do
    let(:subject) do
      AssistanceApplicationForm.new(double("fake application"))
    end

    it_should_behave_like "pdf component"
  end

  describe "#fill?" do
    it "responds to fill? and returns true" do
      form = AssistanceApplicationForm.new(double("fake application"))
      expect(form.fill?).to be_truthy
    end
  end

  describe "#attributes" do
    context "an application with one member" do
      let(:primary_member) do
        build(:household_member,
          first_name: "Octopus",
          last_name: "Cuttlefish",
          relationship: "primary",
          birthday: DateTime.new(1991, 10, 18),
          sex: "male",
          ssn: "123456789",
          requesting_food: "yes",
          requesting_healthcare: "yes",
          married: "yes",
          student: "yes",
          disabled: "yes",
          citizen: "yes",
          veteran: "yes",
          pregnant: "no",
          pregnancy_expenses: "yes",
          employments: [
            build(:employment,
              employer_name: "Sunnydale High School",
              hourly_or_salary: "hourly",
              hours_per_week: "20",
              pay_quantity: "15",
              payment_frequency: "week"),
          ],
          self_employed: "yes",
          self_employment_description: "cake maker",
          self_employment_income: 100,
          self_employment_expense: 50,
          additional_incomes: [build(:additional_income, income_type: "unemployment", amount: 100)],
          accounts: [
            build(:account, account_type: "checking", institution: "Test Credit Union"),
            build(:account, account_type: "payroll_benefits", institution: "Whalemart"),
          ],
          vehicles: [
            build(:vehicle, vehicle_type: "car", year_make_model: "1990 Toyota Corolla"),
            build(:vehicle, vehicle_type: "motorcycle", year_make_model: "1952 Vincent HRD"),
          ])
      end

      let(:common_application) do
        create(:common_application,
           members: [primary_member],
           expenses: [
             build(:expense, expense_type: "health_insurance", amount: 100, members: [primary_member]),
             build(:expense, expense_type: "childcare", amount: 100, members: [primary_member]),
             build(:expense, expense_type: "child_support", amount: 100, members: [primary_member]),
             build(:expense, expense_type: "student_loan_interest", amount: 100, members: [primary_member]),
           ],
           residential_address: build(:residential_address,
                                      address_type: "residential",
                                      street_address: "123 Main St",
                                      street_address_2: "Apt B",
                                      city: "Flint",
                                      county: "Genesee",
                                      state: "MI",
                                      zip: "48480"),
           mailing_address: build(:mailing_address,
                                  address_type: "mailing",
                                  street_address: "456 Mailing Ave",
                                  street_address_2: "Suite 500",
                                  city: "Flint",
                                  county: "Genesee",
                                  state: "MI",
                                  zip: "48480"),
           email: "jessie@example.com",
           phone_number: "2024561111",
           sms_phone_number: "2024561122",
           properties: ["rental"],
           previously_received_assistance: "yes",
           living_situation: "temporary_address",
           income_changed: "yes",
           income_changed_explanation: "I lost my job.",
           authorized_representative: "yes",
           authorized_representative_name: "Trusty McTrusterson",
           authorized_representative_phone: "2024561111",
           additional_information: "Lost my job, staying with a friend for two weeks",
           signature: "Octopus Cuttlefish",
           signed_at: DateTime.new(2018, 4, 1))
      end

      let(:attributes) do
        AssistanceApplicationForm.new(common_application).attributes
      end

      it "returns a hash with basic information" do
        expect(attributes).to include(
          applying_for_food: "Yes",
          applying_for_healthcare: "Yes",
          first_member_requesting_food: Integrated::PdfAttributes::UNDERLINED,
          first_member_requesting_healthcare: Integrated::PdfAttributes::UNDERLINED,
          legal_name: "Octopus Cuttlefish",
          dob: "10/18/1991",
          ssn: "123-45-6789",
          email: "jessie@example.com",
          phone_cell: "(202) 456-1122",
          phone_home: "(202) 456-1111",
          received_assistance: "Yes",
          is_homeless: "Yes",
          residential_address_street: "123 Main St",
          residential_address_apt: "Apt B",
          residential_address_city: "Flint",
          residential_address_county: "Genesee",
          residential_address_state: "MI",
          residential_address_zip: "48480",
          mailing_address: "456 Mailing Ave, Suite 500, Flint, MI 48480",
          first_member_dob: "10/18/1991",
          first_member_male: Integrated::PdfAttributes::CIRCLED,
          first_member_female: nil,
          first_member_married_yes: Integrated::PdfAttributes::CIRCLED,
          first_member_married_no: nil,
          first_member_citizen_yes: Integrated::PdfAttributes::CIRCLED,
          first_member_citizen_no: nil,
          anyone_in_college: "Yes",
          anyone_in_college_names: "Octopus Cuttlefish",
          anyone_disabled: "Yes",
          anyone_disabled_names: "Octopus Cuttlefish",
          anyone_a_veteran: "Yes",
          anyone_a_veteran_names: "Octopus Cuttlefish",
          anyone_recently_pregnant: "Yes",
          anyone_recently_pregnant_names: "Octopus Cuttlefish",
          anyone_assets_accounts: "Yes",
          assets_accounts_checking: "Yes",
          assets_accounts_other: "Yes",
          assets_accounts_other_payroll_benefits: Integrated::PdfAttributes::UNDERLINED,
          first_member_assets_accounts_name: "Octopus Cuttlefish",
          first_member_assets_accounts_account_type: "Checking",
          first_member_assets_accounts_institution: "Test Credit Union",
          second_member_assets_accounts_name: "Octopus Cuttlefish",
          second_member_assets_accounts_account_type: "Payroll/Benefits card",
          second_member_assets_accounts_institution: "Whalemart",
          anyone_assets_vehicles: "Yes",
          assets_vehicles_car: "Yes",
          assets_vehicles_motorcycle: "Yes",
          first_member_assets_vehicles_name: "Octopus Cuttlefish",
          first_member_assets_vehicles_year_make_model: "1990 Toyota Corolla",
          second_member_assets_vehicles_name: "Octopus Cuttlefish",
          second_member_assets_vehicles_year_make_model: "1952 Vincent HRD",
          anyone_medical_expenses: "Yes",
          anyone_income_change: "Yes",
          anyone_income_change_explanation: "I lost my job.",
          anyone_employed: "Yes",
          first_member_employment_name: "Octopus Cuttlefish",
          first_member_employment_frequency_hour: Integrated::PdfAttributes::CIRCLED,
          first_member_employment_frequency_week: Integrated::PdfAttributes::CIRCLED,
          first_member_employment_employer_name: "Sunnydale High School",
          first_member_employment_hrs_per_wk: "20",
          first_member_employment_amount: "15",
          anyone_self_employed: "Yes",
          first_member_self_employed_name: "Octopus Cuttlefish",
          first_member_self_employed_type: "cake maker",
          first_member_self_employed_monthly_income: 100,
          first_member_self_employed_monthly_expenses: 50,
          anyone_additional_income: "Yes",
          additional_income_unemployment: "Yes",
          first_member_additional_income_name: "Octopus Cuttlefish",
          first_member_additional_income_type: "Unemployment",
          first_member_additional_income_amount: 100,
          first_member_additional_income_frequency_month: Integrated::PdfAttributes::CIRCLED,
          medical_expenses_health_insurance: "Yes",
          wants_authorized_representative: "Yes",
          authorized_representative_full_name: "Trusty McTrusterson",
          authorized_representative_phone_number: "(202) 456-1111",
          anyone_expenses_dependent_care: "Yes",
          dependent_care_childcare: "Yes",
          first_member_dependent_care_name: "Octopus Cuttlefish",
          first_member_dependent_care_amount: 100,
          first_member_dependent_care_payment_frequency: "Monthly",
          first_member_medical_expenses_name: "Octopus Cuttlefish",
          first_member_medical_expenses_type: "Health Insurance",
          first_member_medical_expenses_amount: 100,
          first_member_medical_payment_frequency: "Monthly",
          anyone_court_expenses: "Yes",
          court_expenses_child_support: "Yes",
          anyone_student_loans_deductions: "Yes",
          first_member_student_loans_deductions_name: "Octopus Cuttlefish",
          first_member_student_loans_deductions_type: "Student loan interest",
          first_member_student_loans_deductions_amount: 100,
          first_member_student_loans_deductions_payment_frequency: "Monthly",
          anyone_assets_property: "Yes",
          assets_property_rental: "Yes",
          signature_applicant: "Octopus Cuttlefish",
          signature_date: "03/31/2018",
          has_additional_info: "Yes",
          additional_info: "Lost my job, staying with a friend for two weeks",
        )
      end
    end

    context "an application with six members" do
      let(:copay_expense) do
        create(:expense, expense_type: :copays, amount: 100)
      end
      let(:health_insurance_expense) do
        create(:expense, expense_type: :health_insurance, amount: 100)
      end
      let(:childcare_expense) do
        create(:expense, expense_type: :childcare, amount: 100)
      end
      let(:transportation_expense) do
        create(:expense, expense_type: :transportation, amount: 100)
      end
      let(:rent_expense) do
        create(:expense, expense_type: :rent, amount: 600)
      end
      let(:homeowners_insurance_expense) do
        create(:expense, expense_type: :homeowners_insurance, amount: 78)
      end
      let(:mobile_home_lot_expense) do
        create(:expense, expense_type: :mobile_home_lot_rent, amount: 300)
      end

      let(:vehicles) do
        [
          create(:vehicle,
            vehicle_type: "car",
            year_make_model: "1990 Toyota Corolla"),
          create(:vehicle,
            vehicle_type: "other",
            year_make_model: "1933 Airship ZRS-4"),
          create(:vehicle,
            vehicle_type: "other",
            year_make_model: "1800 Fulton Nautilus Submarine"),
        ]
      end

      let(:accounts) do
        [
          create(:account, account_type: "checking", institution: "Bank of Hank"),
          create(:account, account_type: "savings", institution: "Bank of Hank"),
          create(:account, account_type: "checking", institution: "Bank of Hank"),
          create(:account, account_type: "savings", institution: "Bank of Hank"),
        ]
      end

      let(:common_application) do
        create(:common_application,
          previously_received_assistance: "yes",
          living_situation: "temporary_address",
          expenses: [
            health_insurance_expense,
            copay_expense,
            transportation_expense,
            childcare_expense,
            rent_expense,
            homeowners_insurance_expense,
            mobile_home_lot_expense,
          ],
          members: [build(:household_member,
            first_name: "Willy",
            last_name: "Wells",
            healthcare_enrolled: "yes",
            flint_water: "yes",
            employments: [build(:employment)],
            self_employed: "yes",
            additional_incomes: [build(:additional_income,
              income_type: "unemployment",
              amount: 100)]),
                    build(:household_member,
                      first_name: "Willy",
                      last_name: "Wiley",
                      healthcare_enrolled: "yes",
                      flint_water: "yes",
                      employments: [build(:employment)],
                      self_employed: "yes",
                      expenses: [health_insurance_expense, childcare_expense],
                      additional_incomes: [build(:additional_income,
                        income_type: "pension",
                        amount: 50)],
                      accounts: [accounts[0], accounts[1]],
                      vehicles: [vehicles[0], vehicles[2]]),
                    build(:household_member,
                      first_name: "Willy",
                      last_name: "Wonka",
                      healthcare_enrolled: "yes",
                      employments: [
                        build(:employment,
                          employer_name: "Oompa Co",
                          hourly_or_salary: "hourly",
                          pay_quantity: 20,
                          payment_frequency: "twice_a_month",
                          hours_per_week: 10),
                      ],
                      self_employed: "yes",
                      self_employment_description: "cake maker",
                      self_employment_income: 100,
                      self_employment_expense: 50,
                      expenses: [copay_expense, childcare_expense],
                      additional_incomes: [
                        build(:additional_income,
                          income_type: "retirement",
                          amount: 100),
                        build(:additional_income,
                          income_type: "social_security",
                          amount: 200),
                      ],
                      accounts: [accounts[0], accounts[2]],
                      vehicles: [vehicles[0], vehicles[1]]),
                    build(:household_member),
                    build(:household_member),
                    build(:household_member,
                      first_name: "Willy",
                      last_name: "Whale",
                      relationship: "child",
                      birthday: DateTime.new(1995, 10, 18),
                      sex: "male",
                      requesting_food: "yes",
                      requesting_healthcare: "yes",
                      healthcare_enrolled: "yes",
                      married: "yes",
                      citizen: "yes",
                      self_employed: "yes",
                      flint_water: "yes",
                      accounts: [accounts[2], accounts[3]],
                      expenses: [transportation_expense, mobile_home_lot_expense])])
      end

      let(:attributes) do
        AssistanceApplicationForm.new(common_application).attributes
      end

      it "returns a hash with key information for multimember households" do
        expect(attributes).to include(
          first_member_dependent_care_name: "Willy Wiley, Willy Wonka",
          first_member_assets_vehicles_name: "Willy Wiley, Willy Wonka",
        )
      end

      it "returns notes with different sections concatenated" do
        expect(attributes).to include(
          household_added_notes: "Yes",
        )
      end

      it "returns notes with different sections concatenated" do
        expect(attributes).to include(
          household_added_notes: "Yes",
        )
        expect(attributes[:notes]).to eq(
          <<~NOTES
            Additional Household Members:
            - Relation: Child, Legal name: Willy Whale, Sex: Male, DOB: 10/18/1995, Married: Yes, Citizen: Yes, Applying for: Food, Healthcare
            Additional Expenses:
            - Transportation for medical care. Willy Whale. $100. Monthly
            - Mobile home lot rent. Willy Whale. $300. Monthly
            Additional Members Currently Enrolled in Health Coverage:
            - Willy Whale
            Additional Members Affected by the Flint Water Crisis:
            - Willy Whale
            Additional Vehicles:
            - Other vehicle: 1800 Fulton Nautilus Submarine (Willy Wiley)
            Additional Accounts:
            - Savings: Bank of Hank (Willy Whale)
            Additional Jobs:
            - Willy Wonka, Oompa Co, Hourly, Paycheck received Twice a month, Rate: 20, 10 hours/week
            Additional Self-Employed Members:
            - Willy Wonka, Cake Maker, Income: $100, Expense: $50
            - Willy Whale
            Additional Income Sources:
            - Willy Wonka, Retirement, $100 per month
            - Willy Wonka, Social Security, $200 per month
          NOTES
        )
      end
    end
  end
end
