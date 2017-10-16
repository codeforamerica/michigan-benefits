require "rails_helper"

RSpec.describe StepsController do
  context "when no applications have been started" do
    it "redirects to the homepage" do
      get :index

      expect(response).to redirect_to(root_path)
    end
  end

  context "when a snap application has been started" do
    it "renders the index page" do
      current_app = create(:snap_application)
      session[:snap_application_id] = current_app.id

      get :index

      expect(response).to render_template(:index)
    end
  end

  context "when a medicaid application has been started" do
    it "renders the index page" do
      current_app = create(:medicaid_application)
      session[:medicaid_application_id] = current_app.id

      get :index

      expect(response).to render_template(:index)
    end
  end
end
