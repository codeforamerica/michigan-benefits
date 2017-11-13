require "rails_helper"

RSpec.describe MedicaidApplicationMemberAttributes do
  describe "#to_h" do
    it "returns the member attributes as a hash" do
      member = create(
        :member,
        first_name: "First",
        last_name: "Last",
      )

      result = MedicaidApplicationMemberAttributes.new(
        member: member,
        position: "primary",
      ).to_h

      expect(result).to eq(
        primary_member_full_name: "First Last",
      )
    end
  end
end
