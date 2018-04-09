require "rails_helper"

RSpec.describe StaticPagesController, type: :controller do
  context "with a current application" do
    describe "#index" do
      it "sets the snap_application_id to nil" do
        session[:snap_application_id] = 1
        session[:medicaid_application_id] = 2
        session[:current_application_id] = 3

        get :index

        expect(session[:snap_application_id]).to be_nil
        expect(session[:medicaid_application_id]).to be_nil
        expect(session[:current_application_id]).to be_nil
      end
    end

    describe "#combined" do
      it "clears applications from session" do
        session[:snap_application_id] = 1
        session[:medicaid_application_id] = 2
        session[:current_application_id] = 3

        get :combined

        expect(session[:snap_application_id]).to be_nil
        expect(session[:medicaid_application_id]).to be_nil
        expect(session[:current_application_id]).to be_nil
      end
    end
  end
end
