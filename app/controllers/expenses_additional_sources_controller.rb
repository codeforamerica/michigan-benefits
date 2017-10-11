# frozen_string_literal: true

class ExpensesAdditionalSourcesController < StandardStepsController
  include SnapFlow

  private

  def step_params
    super.tap do |params_hash|
      params_hash.each do |key, val|
        params_hash[key] = val == "true"
      end
    end
  end
end
