# frozen_string_literal: true

require "rails_helper"

RSpec.describe HouseholdMoreInfoController do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { everyone_a_citizen: "" } } }
  let(:step_class) { HouseholdMoreInfo }

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller", "param validation"

  def current_app
    @_current_app ||= create(:snap_application)
  end
end
