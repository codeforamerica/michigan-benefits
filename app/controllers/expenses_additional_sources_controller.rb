# frozen_string_literal: true

class ExpensesAdditionalSourcesController < StandardStepsController
  private

  def step_params
    super.tap do |params_hash|
      params_hash.each do |key, val|
        params_hash[key] = if val == "true"
                             true
                           else
                             false
                           end
      end
    end
  end
end
