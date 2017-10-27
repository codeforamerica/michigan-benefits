require "rails_helper"

RSpec.describe Medicaid::ExpensesAlimonyController, type: :controller do
  describe "#next_path" do
    it "is the student loan expenses page path" do
      expect(subject.next_path).to eq "/steps/medicaid/expenses-alimony-member"
    end
  end
end
