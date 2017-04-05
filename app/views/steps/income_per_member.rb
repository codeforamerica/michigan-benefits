class Views::Steps::IncomePerMember < Views::Base
  needs :app, :step, :f

  def content
    app.household_members.each do |member|
      f.fields_for "household_members[]", member, hidden_field_id: true do |ff|

        if member.employed?
          headline member.full_name
          help_text member.employment_status.humanize

          question ff, :employer_name, "Employer name" do
            text_field ff, :employer_name, "Employer"
          end

          question ff, :hours_per_week, "Usual hours per week" do
            number_field ff, :hours_per_week
          end

          question ff, :pay_quantity, "Pay (before tax)" do
            help_text "This includes money withheld from paychecks"
            money_field ff, :pay_quantity

            label "per" do
              select_field ff, :pay_interval, step.pay_intervals
            end
          end

          question ff, :income_consistent, "Is this income consistent month-to-month?" do
            yes_no_field ff, :income_consistent
          end
        end

        if member.self_employed?
          headline member.full_name
          help_text member.employment_status.humanize

          question ff, :profession, "Type of work" do
            text_field ff, :profession, "Profession"
          end

          question ff, :monthly_pay, "Monthly pay (before tax)" do
            money_field ff, :monthly_pay
          end

          question ff, :income_consistent, "Is this income consistent month-to-month?" do
            yes_no_field ff, :income_consistent
          end

          question ff, :monthly_expenses, "Monthly expenses" do
            money_field ff, :monthly_expenses
          end
        end
      end
    end
  end
end
