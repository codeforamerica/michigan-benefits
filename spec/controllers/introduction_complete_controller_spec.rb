# frozen_string_literal: true

require "rails_helper"

RSpec.describe IntroductionCompleteController do
  before { session[:snap_application_id] = current_app.id }

  describe "#update" do
    it "redirects to next step" do
      put :update, params: {}

      expect(response).to redirect_to("/steps/personal-detail")
    end
  end

  def current_app
    @_current_app ||= create(:snap_application)
  end
end
