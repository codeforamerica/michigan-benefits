# frozen_string_literal: true

class ManyMemberUpdateStep < Step
  attr_accessor :household_members

  def update(params)
    household_members.each do |household_member|
      attrs = params.dig('household_members', household_member.to_param) || {}
      household_member.assign_attributes(attrs)
      validate_household_member(household_member)
    end

    if valid?
      ActiveRecord::Base.transaction do
        household_members.each(&:save!)
      end
    end
  end

  def assign_from_app
    self.household_members = @app.household_members
  end

  def valid?
    household_members.all? { |member| member.errors.blank? }
  end

  def validate_household_member(household_member)
    # override me
  end
end
