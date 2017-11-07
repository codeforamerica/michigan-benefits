require "rails_helper"

RSpec.describe NullMember do
  describe "#display_name" do
    it "returns empty string" do
      expect(NullMember.new.display_name).to eq ""
    end
  end

  describe "#birthday" do
    it "returns nil" do
      expect(NullMember.new.birthday).to eq nil
    end
  end
end
