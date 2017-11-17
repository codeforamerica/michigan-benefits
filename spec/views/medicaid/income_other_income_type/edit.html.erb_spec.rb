require "rails_helper"

describe "medicaid/income_other_income_type/edit.html.erb" do
  before do
    controller.singleton_class.class_eval do
      def current_path
        "/steps/medicaid/income-other-income-type"
      end

      def current_member
        Member.last
      end

      def current_application
        current_member.benefit_application
      end

      helper_method :current_path, :current_application, :current_member
    end
  end

  context "has not selected another income type" do
    it "shows an error message" do
      member = create(:member, other_income: true)
      step = Medicaid::IncomeOtherIncomeType.new(
        other_income_types: [],
        member_id: member.id,
      ).tap(&:valid?)

      assign(:step, step)

      render

      expect(rendered).to include(
        "Please select at least one other income type",
      )
    end
  end
end
