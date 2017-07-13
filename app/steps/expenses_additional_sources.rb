# frozen_string_literal: true

class ExpensesAdditionalSources < Step
  self.title = 'Expenses'
  self.subhead = 'Tell us more about your expenses.'
  self.subhead_help = 'These expenses help inform how significant your benefits may be. Please include all expenses you can.'

  self.questions = {
    dependent_care: 'Does your household have dependent care expenses?',
    medical: 'Does your household have medical expenses?',
    court_ordered: 'Does your household have court-ordered expenses?',
    tax_deductible: 'Does your household have tax deductible expenses?'
  }

  self.types = {
    dependent_care: :yes_no,
    medical: :yes_no,
    court_ordered: :yes_no,
    tax_deductible: :yes_no
  }

  self.help_messages = {
    dependent_care: 'This includes child care (including day care and after school programs), elderly care, and adult disabled care.',
    medical: 'This includes health insurance, co-pays, prescriptions, dental, hospital bills, etc.',
    court_ordered: 'This includes child support, alimony, etc.',
    tax_deductible: 'This includes student loan interest and any other expense that can be deducted on your tax return.'
  }

  attr_accessor \
    :dependent_care,
    :medical,
    :court_ordered,
    :tax_deductible

  validates :dependent_care,
    :medical,
    :court_ordered,
    :tax_deductible,
    presence: { message: 'Make sure to answer this question' }

  def assign_from_app
    assign_attributes @app.attributes.slice('dependent_care', 'medical', 'court_ordered', 'tax_deductible')
  end

  def update_app!
    @app.update! \
      dependent_care: dependent_care,
      medical: medical,
      court_ordered: court_ordered,
      tax_deductible: tax_deductible
  end
end
