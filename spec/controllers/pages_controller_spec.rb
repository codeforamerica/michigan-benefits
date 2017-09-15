require "rails_helper"

RSpec.describe PagesController, type: :controller do
  describe "#index" do
    it "sets the snap_application_id to nil" do
      get :index

      expect(session[:snap_application_id]).to eq nil
    end
  end
end
