# frozen_string_literal: true

require "rails_helper"

RSpec.describe HouseholdMember, type: :model do
  describe ".with_inconsistent_income" do
    it "returns HouseholdMembers with inconsistent income" do
      described_class.create!(first_name: "alice", income_consistent: false, app: app)
      described_class.create!(first_name: "bob", income_consistent: nil, app: app)

      expect(
        described_class.with_inconsistent_income.map(&:first_name),
      ).to eq(%w[alice bob])
    end

    it "does not return HouseholdMembers with consistent income" do
      described_class.create!(income_consistent: true, app: app)
      expect(described_class.with_inconsistent_income).to be_empty
    end
  end

  def app
    @_app ||= App.create
  end
end
