class IncomeOtherAssetsController < StandardStepsController
  include SnapFlow

  def self.step_class
    IncomeOtherAssets
  end
end
