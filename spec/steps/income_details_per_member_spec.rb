# frozen_string_literal: true

require "rails_helper"

RSpec.describe IncomeDetailsPerMember do
  describe "#working_members" do
    it "returns members who are employed or self employed" do
      working = create(:member, employment_status: "employed")
      not_working = create(:member, employment_status: "not_employed")
      self_employed = create(:member, employment_status: "self_employed")
      members = [working, not_working, self_employed]
      snap_application = create(:snap_application, members: members)

      step = IncomeDetailsPerMember.new(members: snap_application.members)

      expect(step.working_members).to match_array([working, self_employed])
    end
  end
end
