class IncomeEmploymentStatusController < ManyMemberStepsController
  private

  def member_attrs
    %i[employment_status]
  end
end
