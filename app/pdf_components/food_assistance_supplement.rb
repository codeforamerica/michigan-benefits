class FoodAssistanceSupplement
  include Integrated::PdfAttributes

  def initialize(benefit_application)
    @benefit_application = benefit_application
  end

  def source_pdf_path
    "app/lib/pdfs/FoodAssistanceProgramSupplement.pdf"
  end

  def fill?
    true
  end

  def attributes
    supplement_attributes
  end

  def output_file
    @_output_file ||= Tempfile.new(["food_assistance_supplement", ".pdf"], "tmp/")
  end

  private

  attr_reader :benefit_application

  def supplement_attributes
    {
      anyone_buys_food_separately: yes_no_or_unfilled(
        yes: non_household_members_applying_for_snap.any?,
        no: non_household_members_applying_for_snap.none?,
      ),
      anyone_buys_food_separately_names: member_names(non_household_members_applying_for_snap),
      anyone_pays_utilities: yes_no_or_unfilled(
        yes: benefit_application.expenses.utilities.any?,
        no: benefit_application.expenses.utilities.none?,
      ),
      anyone_pays_housing_expenses: yes_no_or_unfilled(
        yes: benefit_application.expenses.housing.any?,
        no: benefit_application.expenses.housing.none?,
      ),
    }.merge(housing_expense_attributes).
      merge(utility_expense_attributes)
  end

  def non_household_members_applying_for_snap
    @_non_household_members_applying_for_snap =
      benefit_application.food_applying_members - benefit_application.food_household_members
  end

  def housing_expense_attributes
    {}.tap do |hash|
      benefit_application.expenses.housing.first(2).each_with_index do |expense, i|
        hash[:"pays_housing_expenses_#{expense.expense_type}"] = "Yes"
        prefix = "#{ordinal_member(i)}_pays_housing_expenses"
        hash[:"#{prefix}_name"] = member_names(expense.members)
        hash[:"#{prefix}_expense_type"] = expense.display_name
        hash[:"#{prefix}_amount"] = expense.amount
        hash[:"#{prefix}_payment_frequency"] = "Monthly"
      end
    end
  end

  def utility_expense_attributes
    {}.tap do |hash|
      benefit_application.expenses.utilities.map(&:expense_type).each do |expense|
        hash[:"pays_utilities_#{expense}"] = "Yes"
      end
    end
  end
end
