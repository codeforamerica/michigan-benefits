require "rails_helper"

RSpec.describe IncomeOtherAssetsController do
  let(:step) { assigns(:step) }
  let(:step_class) { IncomeOtherAssets }
  let(:invalid_params) { { step: { vehicle_income: "" } } }
  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller", "param validation"

  def current_app
    @_current_app ||= create(:snap_application)
  end
end
