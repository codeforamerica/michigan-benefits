require "rails_helper"

RSpec.describe Medicaid::IntroCitizenController, type: :controller do
  describe "#next_path" do
    it "is the citizen selector page path" do
      expect(subject.next_path).to eq "/steps/medicaid/citizens"
    end
  end
end
