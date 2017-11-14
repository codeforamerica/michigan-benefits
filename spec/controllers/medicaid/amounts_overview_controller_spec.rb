# frozen_string_literal: true

require "rails_helper"

RSpec.describe Medicaid::AmountsOverviewController do
  describe "#skip?" do
    before do
      medicaid_application = create(:medicaid_application)
      session[:medicaid_application_id] = medicaid_application.id
    end

    context "receives an income, and has expenses" do
      it "does not skip" do
        allow(subject).to receive(:no_income?).and_return(false)
        allow(subject).to receive(:no_expenses?).and_return(false)

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "receives an income, and has no expenses" do
      it "does not skip" do
        allow(subject).to receive(:no_income?).and_return(false)
        allow(subject).to receive(:no_expenses?).and_return(true)

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "has expenses, and no income" do
      it "does not skip" do
        allow(subject).to receive(:no_expenses?).and_return(false)
        allow(subject).to receive(:no_income?).and_return(true)

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "no income, no expenses" do
      it "skips to the next page" do
        allow(subject).to receive(:no_expenses?).and_return(true)
        allow(subject).to receive(:no_income?).and_return(true)

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end
  end
end
