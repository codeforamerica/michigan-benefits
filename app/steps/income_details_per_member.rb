# frozen_string_literal: true

class IncomeDetailsPerMember < Step
  step_attributes :members

  def working_members
    members.where(employment_status: ["employed", "self_employed"])
  end
end
