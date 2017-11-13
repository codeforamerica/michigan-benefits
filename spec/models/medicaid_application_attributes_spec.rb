require "rails_helper"

RSpec.describe MedicaidApplicationAttributes do
  describe "#to_h" do
    it "returns a hash of attributes" do
      medicaid_application = create(
        :medicaid_application,
        signature: "Jane Hancock",
      )

      data = MedicaidApplicationAttributes.new(
        medicaid_application: medicaid_application,
      ).to_h

      expect(data).to eq(
        signature: "Jane Hancock",
      )
    end
  end
end
