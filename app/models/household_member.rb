class HouseholdMember < ApplicationRecord
  belongs_to :common_application

  enum sex: { unfilled: 0, male: 1, female: 2 }, _prefix: :sex

  def display_name
    @_display_name ||= generate_unique_display_name
  end

  private

  def formatted_name(first_name, last_name)
    "#{first_name.upcase_first} #{last_name.upcase_first}"
  end

  def generate_unique_display_name
    other_members = common_application.members - [self]
    other_member_names = other_members.map do |m|
      formatted_name(m.first_name, m.last_name)
    end
    my_name = formatted_name(first_name, last_name)

    if other_member_names.include?(my_name)
      my_name + " (#{birthday.strftime('%-m/%-d/%Y')})"
    else
      my_name
    end
  end
end
