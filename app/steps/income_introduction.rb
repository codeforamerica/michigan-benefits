# frozen_string_literal: true

class IncomeIntroduction < Step
  self.title = 'Money & Income'
  self.subhead = 'Next, describe your financial situation for us.'
  self.icon = 'section-2'
  self.headline = 'You’re doing great!'

  def assign_from_app; end

  def update_app!; end
end
