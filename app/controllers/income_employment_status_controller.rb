# frozen_string_literal: true

class IncomeEmploymentStatusController < ManyMemberStepsController
  include SnapFlow

  private

  def member_attrs
    %i[employment_status]
  end
end
