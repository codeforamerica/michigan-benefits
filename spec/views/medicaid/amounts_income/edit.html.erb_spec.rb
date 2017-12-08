require "rails_helper"

describe "medicaid/amounts_income/edit.html.erb" do
  before do
    controller.singleton_class.class_eval do
      def current_path
        "/steps/medicaid/amounts-income"
      end

      helper_method :current_path
    end
  end

  context "2 employments for primary member" do
    it "renders a fieldset for each employment" do
      controller.singleton_class.class_eval do
        def current_member
          FactoryBot.build(:member)
        end

        def current_application
          FactoryBot.create(:medicaid_application, members: [current_member])
        end

        helper_method :current_application
        helper_method :current_member
      end

      @step = Medicaid::AmountsIncome.new(
        id: controller.current_member.id,
        employments: [
          create(:employment),
          create(:employment),
        ],
      )

      render

      expect(rendered).to have_selector("fieldset", count: 2)
      expect(rendered).to have_selector("legend", count: 2)
      expect(rendered).to have_selector("legend", text: "Job #1")
      expect(rendered).to have_selector("legend", text: "Job #2")
    end
  end
end
