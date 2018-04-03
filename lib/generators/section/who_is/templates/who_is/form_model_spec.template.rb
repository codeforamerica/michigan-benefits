require "rails_helper"

RSpec.describe WhoIs<%= model_name %>Form do
  describe "validations" do
    context "when no members are <%= model_method %>" do
      it "is invalid" do
        members = build_list(:household_member, 2, <%= model_method %>: "no")
        form = WhoIs<%= model_name %>Form.new(members: members)

        expect(form).to_not be_valid
      end
    end

    context "when at least one member is <%= model_method %>" do
      it "is valid" do
        members = build_list(:household_member, 2, <%= model_method %>: "yes")
        form = WhoIs<%= model_name %>Form.new(members: members)

        expect(form).to be_valid
      end
    end
  end
end
