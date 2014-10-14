require 'rails_helper'

describe Metrics do
  it "returns signups per week (last 12 weeks)" do
    travel_to Time.zone.local(2014, 4, 1) do
      create(:account)
    end

    travel_to Time.zone.local(2014, 8, 11) do
      create(:account)
      create(:account)
      create(:account)
    end

    travel_to Time.zone.local(2014, 8, 26) do
      create(:account)
      create(:account)
    end

    travel_to Time.zone.local(2014, 10, 31) do # Friday
      metrics = Metrics.signups_per_week

      expect(metrics.length).to eq(12)
      expect(metrics[0][:count]).to eq(3)
      expect(metrics[1][:count]).to eq(0)
      expect(metrics[2][:count]).to eq(2)

      expect(metrics[0][:start]).to eq(Date.new(2014, 8, 11))
      expect(metrics[0][:finish]).to eq(Date.new(2014, 8, 17))
      expect(metrics[1][:start]).to eq(Date.new(2014, 8, 18))
      expect(metrics[1][:finish]).to eq(Date.new(2014, 8, 24))
    end
  end

  it "returns signups per day in the last week" do
    travel_to Time.zone.local(2014, 10, 24) do
      create(:account)
    end

    travel_to Time.zone.local(2014, 10, 25) do
      create(:account)
      create(:account)
      create(:account)
    end

    travel_to Time.zone.local(2014, 10, 27) do
      create(:account)
      create(:account)
    end

    travel_to Time.zone.local(2014, 10, 31) do # Friday
      metrics = Metrics.signups_per_day

      expect(metrics.length).to eq(7)
      expect(metrics[0][:count]).to eq(3)
      expect(metrics[1][:count]).to eq(0)
      expect(metrics[2][:count]).to eq(2)

      expect(metrics[0][:start]).to eq(Date.new(2014, 10, 25))
      expect(metrics[1][:start]).to eq(Date.new(2014, 10, 26))
    end
  end
end
