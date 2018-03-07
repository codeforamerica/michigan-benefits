class HouseholdMember < ApplicationRecord
  belongs_to :common_application

  enum sex: { unfilled: 0, male: 1, female: 2 }, _prefix: :sex

  enum relationship: {
    unknown_relation: 0,
    primary: 1,
    roommate: 2,
    spouse: 3,
    unmarried_partner: 4,
    parent: 5,
    sibling: 6,
    child: 7,
    other_relation: 8,
  }, _prefix: :is

  RELATIONSHIP_LABELS_AND_KEYS = [
    ["Choose one", "unknown_relation"],
    ["Roommate", "roommate"],
    ["Spouse", "spouse"],
    ["Unmarried Partner", "unmarried_partner"],
    ["Parent", "parent"],
    ["Sibling", "sibling"],
    ["Child", "child"],
    ["Other", "other_relation"],
  ].freeze

  RELATION_LABEL_LOOKUP = RELATIONSHIP_LABELS_AND_KEYS.map(&:reverse).to_h

  def display_name
    @_display_name ||= generate_unique_display_name
  end

  def relationship_label
    return "You" if relationship == "primary"
    return "" if relationship == "unknown_relation"
    RELATION_LABEL_LOOKUP[relationship]
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

    if other_member_names.include?(my_name) && birthday.present?
      my_name + " (#{birthday.strftime('%-m/%-d/%Y')})"
    else
      my_name
    end
  end
end
