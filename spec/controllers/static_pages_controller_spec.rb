require "rails_helper"

RSpec.describe StaticPagesController, type: :controller do
  describe "#index" do
    it "sets the snap_application_id to nil" do
      get :index

      expect(session[:snap_application_id]).to be_nil
    end
  end
end
