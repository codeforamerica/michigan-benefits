class Views::Steps::IncomeAdditional < Views::Base
  needs :app, :step, :f

  def content
    {
      income_unemployment: "Unemployment Insurance",
      income_ssi: "SSI or Disability",
      income_workers_comp: "Worker's Compensation",
      income_pension: "Pension",
      income_social_security: "Social Security",
      income_child_support: "Child Support",
      income_foster_care: "Foster Care or Adoption Subsidies",
      income_other: "Other Income",
    }.each do |income_type, title|

      if app.additional_income.include? income_type.to_s.remove("income_")
        question f, income_type, title do
          help_text "Monthly amount"
          money_field f, income_type
        end
      end
    end
  end
end
