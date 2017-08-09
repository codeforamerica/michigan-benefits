# frozen_string_literal: true

require "rails_helper"

RSpec.describe SuccessController do
  describe "#edit" do
    it "assigns to a null step" do
      current_app = FactoryGirl.create(:snap_application)
      session[:snap_application_id] = current_app.id

      get :edit

      expect(assigns(:step)).to be_an_instance_of NullStep
    end
  end

  context "in order to not allow going back" do
    describe "#previous_path" do
      it "returns nil" do
        expect(subject.previous_path).to eq nil
      end
    end
  end
end
