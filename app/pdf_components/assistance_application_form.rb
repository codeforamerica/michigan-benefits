class AssistanceApplicationForm
  include Integrated::PdfAttributes

  def initialize(benefit_application)
    @benefit_application = benefit_application
  end

  def source_pdf_path
    "app/lib/pdfs/AssistanceApplication.pdf"
  end

  def fill?
    true
  end

  def attributes
    applicant_registration_attributes.
      merge(member_attributes).
      merge(medical_expenses_attributes).
      merge(care_expenses_attributes).
      merge(court_expenses_attributes).
      merge(student_loan_interest_expense_attributes).
      merge(employed_attributes).
      merge(self_employed_attributes).
      merge(assets_attributes).
      merge(account_assets_attributes).
      merge(additional_income_attributes).
      merge(additional_notes_attributes)
  end

  def output_file
    @_output_file ||= Tempfile.new(["assistance_app", ".pdf"], "tmp/")
  end

  private

  attr_reader :benefit_application

  def applicant_registration_attributes
    {
      applying_for_food: yes_if_true(benefit_application.primary_member.requesting_food_yes?),
      applying_for_healthcare: yes_if_true(benefit_application.primary_member.requesting_healthcare_yes?),
      legal_name: benefit_application.display_name,
      residential_address_street: benefit_application.residential_address&.street_address,
      residential_address_apt: benefit_application.residential_address&.street_address_2,
      residential_address_city: benefit_application.residential_address&.city,
      residential_address_county: benefit_application.residential_address&.county,
      residential_address_state: benefit_application.residential_address&.state,
      residential_address_zip: benefit_application.residential_address&.zip,
      mailing_address: formatted_full_address(benefit_application.mailing_address),
      dob: mmddyyyy_date(benefit_application.primary_member.birthday),
      ssn: formatted_ssn(benefit_application.primary_member.ssn),
      phone_home: formatted_phone(benefit_application.phone_number),
      phone_cell: formatted_phone(benefit_application.sms_phone_number),
      email: benefit_application.email,
      completion_signature_applicant: benefit_application.signature,
      completion_signature_date: mmddyyyy_date(benefit_application.signed_at, "Eastern Time (US & Canada)"),
      has_additional_info: yes_no_or_unfilled(
        yes: benefit_application.additional_information.present?,
        no: benefit_application.additional_information.blank?,
      ),
      additional_info: benefit_application.additional_information,
      received_assistance: yes_no_or_unfilled(
        yes: benefit_application.previously_received_assistance_yes?,
        no: benefit_application.previously_received_assistance_no?,
      ),
      is_homeless: yes_no_or_unfilled(
        yes: benefit_application.homeless? || benefit_application.temporary_address?,
        no: benefit_application.stable_address?,
      ),
      anyone_in_college: yes_no_or_unfilled(yes_no_for(:student)),
      anyone_in_college_names: member_names(benefit_application.members.select(&:student_yes?)),
      anyone_disabled: yes_no_or_unfilled(yes_no_for(:disabled)),
      anyone_disabled_names: member_names(benefit_application.members.select(&:disabled_yes?)),
      anyone_a_veteran: yes_no_or_unfilled(yes_no_for(:veteran)),
      anyone_a_veteran_names: member_names(benefit_application.members.select(&:veteran_yes?)),
      anyone_recently_pregnant: yes_no_or_unfilled(
        yes: benefit_application.members.any?(&:pregnant_yes?) ||
          benefit_application.members.any?(&:pregnancy_expenses_yes?),
        no: benefit_application.members.none?(&:pregnant_yes?) &&
          benefit_application.members.none?(&:pregnancy_expenses_yes?),
      ),
      anyone_recently_pregnant_names: member_names(recently_pregnant_members),
      anyone_medical_expenses: yes_no_or_unfilled(
        yes: benefit_application.expenses.medical.any?,
        no: benefit_application.expenses.medical.none?,
      ),
      anyone_income_change: yes_no_or_unfilled(
        yes: benefit_application.income_changed_yes?,
        no: benefit_application.income_changed_no?,
      ),
      anyone_income_change_explanation: benefit_application.income_changed_explanation,
      wants_authorized_representative: yes_no_or_unfilled(
        yes: benefit_application.authorized_representative_yes?,
        no: benefit_application.authorized_representative_no?,
      ),
      authorized_representative_full_name: benefit_application.authorized_representative_name,
      authorized_representative_phone_number: formatted_phone(benefit_application.authorized_representative_phone),
      anyone_expenses_dependent_care: yes_no_or_unfilled(
        yes: benefit_application.expenses.dependent_care.any?,
        no: benefit_application.expenses.dependent_care.none?,
      ),
      anyone_court_expenses: yes_no_or_unfilled(
        yes: benefit_application.expenses.court_ordered.any?,
        no: benefit_application.expenses.court_ordered.none?,
      ),
      anyone_student_loans_deductions: yes_no_or_unfilled(
        yes: benefit_application.expenses.student_loan_interest.any?,
        no: benefit_application.expenses.student_loan_interest.none?,
      ),
    }
  end

  def member_attributes
    {}.tap do |hash|
      benefit_application.members.first(5).each_with_index do |member, i|
        prefix = ordinal_member(i)
        hash[:"#{prefix}_relation"] = member.relationship_label
        hash[:"#{prefix}_legal_name"] = member.display_name
        hash[:"#{prefix}_dob"] = mmddyyyy_date(member.birthday)
        hash[:"#{prefix}_male"] = circle_if_true(member.sex_male?)
        hash[:"#{prefix}_female"] = circle_if_true(member.sex_female?)
        hash[:"#{prefix}_married_yes"] = circle_if_true(member.married_yes?)
        hash[:"#{prefix}_married_no"] = circle_if_true(member.married_no?)
        hash[:"#{prefix}_citizen_yes"] = circle_if_true(member.citizen_yes?)
        hash[:"#{prefix}_citizen_no"] = circle_if_true(member.citizen_no?)
        hash[:"#{prefix}_requesting_food"] = underline_if_true(member.requesting_food_yes?)
        hash[:"#{prefix}_requesting_healthcare"] = underline_if_true(member.requesting_healthcare_yes?)
      end
    end
  end

  def care_expenses_attributes
    {}.tap do |hash|
      benefit_application.expenses.dependent_care.each_with_index do |expense, i|
        prefix = ordinal_member(i)
        hash["dependent_care_#{expense.expense_type}".to_sym] = "Yes"
        hash[:"#{prefix}_dependent_care_name"] = member_names(expense.members)
        hash[:"#{prefix}_dependent_care_amount"] = expense.amount
        hash[:"#{prefix}_dependent_care_payment_frequency"] = "Monthly"
      end
    end
  end

  def medical_expenses_attributes
    {}.tap do |hash|
      medical_expenses = benefit_application.expenses.medical.map do |expense|
        hash["medical_expenses_#{expense.expense_type}".to_sym] = "Yes"
        expense
      end

      medical_expenses.first(2).each_with_index do |expense, i|
        prefix = ordinal_member(i)
        hash[:"#{prefix}_medical_expenses_name"] = member_names(expense.members)
        hash[:"#{prefix}_medical_expenses_type"] = expense.display_name
        hash[:"#{prefix}_medical_expenses_amount"] = expense.amount
        hash[:"#{prefix}_medical_payment_frequency"] = "Monthly"
      end
    end
  end

  def court_expenses_attributes
    {}.tap do |hash|
      court_ordered_expenses = benefit_application.expenses.court_ordered.map do |expense|
        hash["court_expenses_#{expense.expense_type}".to_sym] = "Yes"
        expense
      end

      court_ordered_expenses.first(2).each_with_index do |expense, i|
        prefix = ordinal_member(i)
        hash[:"#{prefix}_court_expenses_name"] = member_names(expense.members)
        hash[:"#{prefix}_court_expenses_amount"] = expense.amount
        hash[:"#{prefix}_court_expenses_payment_frequency"] = "Monthly"
      end
    end
  end

  def student_loan_interest_expense_attributes
    {}.tap do |hash|
      benefit_application.expenses.student_loan_interest.each_with_index do |expense, i|
        prefix = ordinal_member(i)
        hash["dependent_care_#{expense.expense_type}".to_sym] = "Yes"
        hash[:"#{prefix}_student_loans_deductions_name"] = member_names(expense.members)
        hash[:"#{prefix}_student_loans_deductions_type"] = "Student loan interest"
        hash[:"#{prefix}_student_loans_deductions_amount"] = expense.amount
        hash[:"#{prefix}_student_loans_deductions_payment_frequency"] = "Monthly"
      end
    end
  end

  def employed_attributes
    hash = {
      anyone_employed: yes_no_or_unfilled(
        yes: benefit_application.anyone_employed?,
        no: !benefit_application.anyone_employed?,
      ),
    }
    jobs = benefit_application.members.map(&:employments).flatten
    jobs.first(2).each_with_index do |job, i|
      prefix = ordinal_member(i)
      hash[:"#{prefix}_employment_name"] = job.application_member.display_name
      hash[:"#{prefix}_employment_employer_name"] = job.employer_name
      hash[:"#{prefix}_employment_hrs_per_wk"] = job.hours_per_week
      hash[:"#{prefix}_employment_amount"] = job.pay_quantity

      hash[:"#{prefix}_employment_frequency_hour"] =
        circle_if_true(job.hourly? || job.payment_frequency == "hour")
      hash[:"#{prefix}_employment_frequency_week"] =
        circle_if_true(job.payment_frequency == "week")
      hash[:"#{prefix}_employment_frequency_two_weeks"] =
        circle_if_true(job.payment_frequency == "two_weeks")
      hash[:"#{prefix}_employment_frequency_twice_a_month"] =
        circle_if_true(job.payment_frequency == "twice_a_month")
      hash[:"#{prefix}_employment_frequency_month"] =
        circle_if_true(job.payment_frequency == "month")
      hash[:"#{prefix}_employment_frequency_year"] =
        circle_if_true(job.salaried? || job.payment_frequency == "year")
    end
    hash
  end

  def self_employed_attributes
    hash = {
      anyone_self_employed: yes_no_or_unfilled(
        yes: benefit_application.members.any?(&:self_employed_yes?),
        no: benefit_application.members.none?(&:self_employed_yes?),
      ),
    }
    members = benefit_application.members.select(&:self_employed_yes?)
    members.first(2).each_with_index do |member, i|
      hash[:"#{ordinal_member(i)}_self_employed_name"] = member.display_name
      hash[:"#{ordinal_member(i)}_self_employed_type"] = member.self_employment_description
      hash[:"#{ordinal_member(i)}_self_employed_monthly_income"] = member.self_employment_income
      hash[:"#{ordinal_member(i)}_self_employed_monthly_expenses"] = member.self_employment_expense
    end
    hash
  end

  def assets_attributes
    {}.tap do |hash|
      hash[:anyone_assets_property] = yes_no_or_unfilled(
        yes: benefit_application.properties.any?,
        no: benefit_application.properties.none?,
      )
      benefit_application.properties.each do |property_type|
        hash[:"assets_property_#{property_type}"] = "Yes"
      end

      hash[:anyone_assets_vehicles] = yes_no_or_unfilled(
        yes: benefit_application.vehicles.any?,
        no: benefit_application.vehicles.none?,
      )
      benefit_application.vehicles.each_with_index do |vehicle, i|
        hash[:"assets_vehicles_#{vehicle.vehicle_type}"] = "Yes"
        if i < 2
          prefix = "#{ordinal_member(i)}_assets_vehicles"
          hash[:"#{prefix}_name"] = vehicle.member_names
          hash[:"#{prefix}_year_make_model"] = vehicle.year_make_model
        end
      end
    end
  end

  def account_assets_attributes
    {}.tap do |hash|
      accounts = benefit_application.accounts
      hash[:anyone_assets_accounts] = yes_no_or_unfilled(
        yes: accounts.any?,
        no: accounts.none?,
      )
      accounts.cash.each do |cash_account|
        hash[:"assets_accounts_#{cash_account.account_type}"] = "Yes"
      end
      hash[:assets_accounts_other] = "Yes" if accounts.other.any?
      accounts.other.each do |other_account|
        hash[:"assets_accounts_other_#{other_account.account_type}"] = UNDERLINED
      end
      accounts.first(3).each_with_index do |account, i|
        prefix = "#{ordinal_member(i)}_assets_accounts"
        hash[:"#{prefix}_name"] = member_names(account.members)
        hash[:"#{prefix}_account_type"] = account.display_name
        hash[:"#{prefix}_institution"] = account.institution
      end
    end
  end

  def additional_income_attributes
    hash = {
      anyone_additional_income: yes_no_or_unfilled(
        yes: benefit_application.anyone_additional_income?,
        no: !benefit_application.anyone_additional_income?,
      ),
    }
    AdditionalIncome::INCOME_SOURCES.each_key do |key|
      hash[:"additional_income_#{key}"] = yes_if_true(benefit_application.anyone_additional_income_of?(key))
    end
    incomes = benefit_application.members.map(&:additional_incomes).flatten
    incomes.first(2).each_with_index do |income, i|
      hash[:"#{ordinal_member(i)}_additional_income_name"] = income.household_member.display_name
      hash[:"#{ordinal_member(i)}_additional_income_type"] = income.display_name
      hash[:"#{ordinal_member(i)}_additional_income_amount"] = income.amount
      hash[:"#{ordinal_member(i)}_additional_income_frequency_month"] = circle_if_true(income.amount?)
    end
    hash
  end

  def additional_notes_attributes
    @_additional_notes = {
      notes: "",
    }
    add_additional_household_members
    add_additional_expenses
    add_additional_members_healthcare_enrolled
    add_additional_members_flint_water
    add_additional_vehicle_assets
    add_additional_account_assets
    add_additional_members_employed
    add_additional_members_self_employed
    add_additional_members_additional_income
    @_additional_notes
  end

  def add_additional_household_members
    if benefit_application.members.count > 5
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Household Members:"
      benefit_application.members[5..-1].each do |extra_member|
        @_additional_notes[:notes] += "\n- Relation: #{extra_member.relationship_label}, "
        @_additional_notes[:notes] += "Legal name: #{extra_member.display_name}, "
        @_additional_notes[:notes] += "Sex: #{extra_member.sex.titleize}, "
        @_additional_notes[:notes] += "DOB: #{mmddyyyy_date(extra_member.birthday)}, "
        @_additional_notes[:notes] += "Married: #{extra_member.married.titleize}, "
        @_additional_notes[:notes] += "Citizen: #{extra_member.citizen.titleize}, "
        if extra_member.requesting_food_yes? || extra_member.requesting_healthcare_yes?
          programs = %w{Food Healthcare}.select do |program|
            extra_member.public_send(:"requesting_#{program.downcase}_yes?")
          end
          @_additional_notes[:notes] += "Applying for: #{programs.join(', ')}\n"
        end
      end
    end
  end

  def add_additional_vehicle_assets
    if benefit_application.vehicles.count > 2
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Vehicles:\n"
      @_additional_notes[:notes] += benefit_application.vehicles[2..-1].map do |extra_vehicle|
        "- #{extra_vehicle.display_name_and_make} (#{extra_vehicle.member_names})\n"
      end.join
    end
  end

  def add_additional_account_assets
    if benefit_application.accounts.count > 3
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Accounts:\n"
      @_additional_notes[:notes] += benefit_application.accounts[3..-1].map do |account|
        "- #{account.display_name}: #{account.institution} (#{member_names(account.members)})\n"
      end.join
    end
  end

  def add_additional_expenses
    medical_expenses = benefit_application.expenses.medical[2..-1] || []
    court_ordered_expenses = benefit_application.expenses.court_ordered[2..-1] || []
    housing_expenses = benefit_application.expenses.housing[2..-1] || []

    additional_expenses = medical_expenses + court_ordered_expenses + housing_expenses
    if additional_expenses.any?
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Expenses:\n"
      @_additional_notes[:notes] += additional_expenses.map do |expense|
        [
          "- #{expense.display_name}",
          member_names(expense.members),
          expense.amount.present? ? "$#{expense.amount}" : nil,
          "Monthly",
        ].compact.join(". ")
      end.join("\n")
      @_additional_notes[:notes] += "\n"
    end
  end

  def add_additional_members_healthcare_enrolled
    members = benefit_application.members.select(&:healthcare_enrolled_yes?)
    if members.count > 3
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Members Currently Enrolled in Health Coverage:\n"
      @_additional_notes[:notes] += members[3..-1].map do |extra_member|
        "- #{extra_member.display_name}\n"
      end.join
    end
  end

  def add_additional_members_flint_water
    members = benefit_application.members.select(&:flint_water_yes?)
    if members.count > 2
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Members Affected by the Flint Water Crisis:\n"
      @_additional_notes[:notes] += members[2..-1].map do |extra_member|
        "- #{extra_member.display_name}\n"
      end.join
    end
  end

  def add_additional_members_employed
    jobs = benefit_application.members.map(&:employments).flatten
    if jobs.count > 2
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Jobs:\n"
      @_additional_notes[:notes] += jobs[2..-1].map do |job|
        [
          "- #{job.application_member.display_name}",
          job.employer_name,
          job.hourly_or_salary&.titleize,
          job.payment_frequency.present? ? "Paycheck received #{job.paycheck_interval_label}" : nil,
          job.pay_quantity.present? ? "Rate: #{job.pay_quantity}" : nil,
          job.hours_per_week.present? ? "#{job.hours_per_week} hours/week" : nil,
        ].compact.join(", ")
      end.join("\n")
      @_additional_notes[:notes] += "\n"
    end
  end

  def add_additional_members_self_employed
    members = benefit_application.members.select(&:self_employed_yes?)
    if members.count > 2
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Self-Employed Members:\n"
      @_additional_notes[:notes] += members[2..-1].map do |extra_member|
        [
          "- #{extra_member.display_name}",
          extra_member.self_employment_description&.titleize,
          extra_member.self_employment_income.present? ? "Income: $#{extra_member.self_employment_income}" : nil,
          extra_member.self_employment_expense.present? ? "Expense: $#{extra_member.self_employment_expense}" : nil,
        ].compact.join(", ")
      end.join("\n")
      @_additional_notes[:notes] += "\n"
    end
  end

  def add_additional_members_additional_income
    additional_incomes = benefit_application.members.map(&:additional_incomes).flatten
    if additional_incomes.count > 2
      @_additional_notes[:household_added_notes] = "Yes"
      @_additional_notes[:notes] += "Additional Income Sources:\n"
      @_additional_notes[:notes] += additional_incomes[2..-1].map do |extra_income|
        [
          "- #{extra_income.household_member.display_name}",
          extra_income.display_name,
          extra_income.amount.present? ? "$#{extra_income.amount} per month" : nil,
        ].compact.join(", ")
      end.join("\n")
      @_additional_notes[:notes] += "\n"
    end
  end

  def recently_pregnant_members
    benefit_application.members.select do |member|
      member.pregnant_yes? || member.pregnancy_expenses_yes?
    end
  end

  def formatted_phone(phone)
    return nil if phone.blank?
    "(#{phone[0..2]}) #{phone[3..5]}-#{phone[6..9]}"
  end

  def formatted_ssn(ssn)
    return nil if ssn.blank?
    "#{ssn[0..2]}-#{ssn[3..4]}-#{ssn[5..8]}"
  end

  def formatted_full_address(address)
    return "" if address.nil?
    [address.street_address, address.street_address_2, address.city, address.state].
      reject(&:blank?).
      join(", ").
      concat(" #{address.zip}")
  end
end
