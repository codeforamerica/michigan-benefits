require "rails_helper"

RSpec.describe StepsController do
  controller do
    def update
      @test = "in update"
      head :no_content
    end

    def edit
      @test = "in edit"
      head :no_content
    end

    def index
      @test = "in index"
      head :no_content
    end
  end

  describe "#edit" do
    before do
      routes.draw { get "edit" => "steps#edit" }
    end

    context "when there is a snap application" do
      it "renders the action as normal" do
        session[:snap_application_id] = create(:snap_application).id

        get "edit"

        expect(assigns[:test]).to eq "in edit"
      end
    end

    context "when there is a medicaid application" do
      it "renders the action as normal" do
        session[:medicaid_application_id] = create(:medicaid_application).id

        get "edit"

        expect(assigns[:test]).to eq "in edit"
      end
    end

    context "when there is no application under way" do
      it "redirects to the specified path" do
        session[:snap_application_id] = nil

        get "edit"

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "#update" do
    before do
      routes.draw { get "update" => "steps#update" }
    end

    context "when there is a snap application" do
      it "renders the action as normal" do
        session[:snap_application_id] = create(:snap_application).id

        get "update"

        expect(assigns[:test]).to eq "in update"
      end
    end

    context "when there is a medicaid application" do
      it "renders the action as normal" do
        session[:medicaid_application_id] = create(:medicaid_application).id

        get "update"

        expect(assigns[:test]).to eq "in update"
      end
    end

    context "when there is no application under way" do
      it "redirects to the specified path" do
        session[:snap_application_id] = nil

        get "update"

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "#index" do
    before do
      routes.draw { get "index" => "steps#index" }
    end

    context "when there is a snap application" do
      it "renders the action as normal" do
        session[:snap_application_id] = create(:snap_application).id

        get "index"

        expect(assigns[:test]).to eq "in index"
      end
    end

    context "when there is a medicaid application" do
      it "renders the action as normal" do
        session[:medicaid_application_id] = create(:medicaid_application).id

        get "index"

        expect(assigns[:test]).to eq "in index"
      end
    end

    context "when there is no application under way" do
      it "redirects to the specified path" do
        session[:snap_application_id] = nil

        get "index"

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
