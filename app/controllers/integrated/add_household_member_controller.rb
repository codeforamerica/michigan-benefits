module Integrated
  class AddHouseholdMemberController < FormsController
    def update_models
      member_data = member_params
      combine_birthday_fields(member_data)
      current_application.members.create(member_data)
    end

    def previous_path(*_args)
      household_members_overview_sections_path
    end

    def next_path
      household_members_overview_sections_path
    end

    private

    def combine_birthday_fields(data)
      year = data.delete(:birthday_year)
      month = data.delete(:birthday_month)
      day = data.delete(:birthday_day)
      if [year, month, day].all? &:present?
        data[:birthday] = DateTime.new(year.to_i, month.to_i, day.to_i)
      end
    end
  end
end
