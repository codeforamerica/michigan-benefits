require "rails_helper"

RSpec.describe FunnelStage do
  it "has a name" do
    name = "Signup"
    funnel_stage = FunnelStage.new(
      cohort: Array.new(3),
      previous_cohort: Array.new(4),
      name: name,
    )
    expect(funnel_stage.name).to eq(name)
  end

  it "understands its own SNAP application count" do
    count = 3
    funnel_stage = FunnelStage.new(
      cohort: Array.new(count),
      previous_cohort: Array.new(4),
      name: "Signup",
    )
    expect(funnel_stage.count).to eq(count)
  end

  it "understands the SNAP application count of the previous stage" do
    previous_count = 4
    funnel_stage = FunnelStage.new(
      cohort: Array.new(3),
      previous_cohort: Array.new(previous_count),
      name: "Signup",
    )
    expect(funnel_stage.previous_count).to eq(previous_count)
  end

  describe "#conversion_rate" do
    context "when given a previous cohort" do
      it "calculates conversion rate normally" do
        funnel_stage = FunnelStage.new(
          cohort: Array.new(3),
          previous_cohort: Array.new(4),
          name: "Signup",
        )
        expect(funnel_stage.conversion_rate).to eq(0.75)
      end
    end

    context "when not given a previous cohort" do
      it "starts from 100% conversion" do
        funnel_stage = FunnelStage.new(
          cohort: Array.new(3),
          previous_cohort: [],
          name: "Signup",
        )
        expect(funnel_stage.conversion_rate).to eq(1.0)
      end
    end
  end
end
