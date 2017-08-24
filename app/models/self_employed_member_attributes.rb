# frozen_string_literal: true

class SelfEmployedMemberAttributes
  def initialize(member:, position:)
    @member = member
    @position = position
  end

  def to_h
    {
      "#{position}_self_employed_full_name" => member.full_name,
      "#{position}_self_employed_profession" => member.self_employed_profession,
      "#{position}_self_employed_monthly_income" =>
        member.self_employed_monthly_income,
      "#{position}_self_employed_monthly_expenses" =>
        member.self_employed_monthly_expenses,
    }.symbolize_keys
  end

  private

  attr_reader :member, :position
end
