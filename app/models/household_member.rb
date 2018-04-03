class HouseholdMember < ApplicationRecord
  belongs_to :common_application

  scope :requesting_food, -> {
    where(requesting_food: "yes").order("created_at")
  }

  scope :requesting_healthcare, -> {
    where(requesting_healthcare: "yes").order("created_at")
  }

  scope :buy_and_prepare_food_together, -> {
    where(buy_and_prepare_food_together: "yes").order("created_at")
  }

  scope :tax_household, -> {
    where(tax_relationship: ["primary", "married_filing_jointly", "dependent"]).order("created_at")
  }

  enum sex: { unfilled: 0, male: 1, female: 2 }, _prefix: :sex
  enum married: { unfilled: 0, yes: 1, no: 2 }, _prefix: :married
  enum caretaker: { unfilled: 0, yes: 1, no: 2 }, _prefix: :caretaker
  enum student: { unfilled: 0, yes: 1, no: 2 }, _prefix: :student
  enum disabled: { unfilled: 0, yes: 1, no: 2 }, _prefix: :disabled
  enum citizen: { unfilled: 0, yes: 1, no: 2 }, _prefix: :citizen
  enum veteran: { unfilled: 0, yes: 1, no: 2 }, _prefix: :veteran
  enum foster_care_at_18: { unfilled: 0, yes: 1, no: 2 }, _prefix: :foster_care_at_18
  enum pregnant: { unfilled: 0, yes: 1, no: 2 }, _prefix: :pregnant
  # Generated enums added above

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

  enum requesting_food: { unfilled: 0, yes: 1, no: 2 }, _prefix: :requesting_food
  enum requesting_healthcare: { unfilled: 0, yes: 1, no: 2 }, _prefix: :requesting_healthcare
  enum filing_taxes_next_year: { unfilled: 0, yes: 1, no: 2 }, _prefix: :filing_taxes_next_year

  enum buy_and_prepare_food_together: { unfilled: 0, yes: 1, no: 2 },
       _prefix: :buy_and_prepare_food_together

  enum tax_relationship: {
    unfilled: 0,
    married_filing_jointly: 1,
    married_filing_separately: 2,
    dependent: 3,
    not_included: 4,
    primary: 5,
  }, _prefix: :tax_relationship

  RELATIONSHIP_LABELS_AND_KEYS = [
    ["Choose one", ""],
    ["Roommate", "roommate"],
    ["Spouse", "spouse"],
    ["Unmarried Partner", "unmarried_partner"],
    ["Parent", "parent"],
    ["Sibling", "sibling"],
    ["Child", "child"],
    ["Other", "other_relation"],
  ].freeze

  TAX_RELATIONSHIP_LABELS_AND_KEYS = [
    ["Choose one", nil],
    ["Married Filing Jointly", "married_filing_jointly"],
    ["Married Filing Separately", "married_filing_separately"],
    ["Dependent", "dependent"],
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

  def age
    return nil if birthday.blank?
    today = Date.today
    age = today.year - birthday.year
    before_birthday = today.strftime("%m%d") < birthday.strftime("%m%d")
    age - (before_birthday ? 1 : 0)
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
