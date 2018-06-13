require "rails_helper"

RSpec.describe FormsController do
  controller do
    def update
      @test = "in update"
      head :no_content
    end

    def edit
      @test = "in edit"
      head :no_content
    end
  end

  describe "#edit" do
    before do
      routes.draw { get "edit" => "forms#edit" }
    end

    context "when there is a common application" do
      it "renders the action as normal" do
        session[:current_application_id] = create(:common_application).id

        get "edit"

        expect(assigns[:test]).to eq "in edit"
      end
    end

    context "when there is no application under way" do
      it "redirects to the specified path" do
        session[:current_application_id] = nil

        get "edit"

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "#update" do
    before do
      routes.draw { get "update" => "forms#update" }
    end

    context "when there is a current application" do
      it "renders the action as normal" do
        session[:current_application_id] = create(:common_application).id

        get "update"

        expect(assigns[:test]).to eq "in update"
      end
    end

    context "when there is no application under way" do
      it "redirects to the specified path" do
        session[:current_application_id] = nil

        get "update"

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
