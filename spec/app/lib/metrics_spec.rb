require 'rails_helper'

describe Metrics do
  it "returns signups per week (last 12 weeks)" do
    travel_to Time.zone.local(2014, 4, 1) do
      1.times { create(:account) }
    end

    travel_to Time.zone.local(2014, 8, 11) do
      3.times { create(:account) }
    end

    travel_to Time.zone.local(2014, 8, 26) do
      2.times { create(:account) }
    end

    travel_to Time.zone.local(2014, 10, 31) do # Friday
      metrics = Metrics.signups_per_week

      expect(metrics[0][:count]).to eq(3)
      expect(metrics[1][:count]).to eq(0)
      expect(metrics[2][:count]).to eq(2)

      expect(metrics[0][:start]).to eq(Date.new(2014, 8, 11))
      expect(metrics[1][:start]).to eq(Date.new(2014, 8, 18))
      expect(metrics.length).to eq(12)
    end
  end

  it "returns signups per day in the last week" do
    travel_to Time.zone.local(2014, 10, 24) do
      1.times { create(:account) }
    end

    travel_to Time.zone.local(2014, 10, 25) do
      3.times { create(:account) }
    end

    travel_to Time.zone.local(2014, 10, 27) do
      2.times { create(:account) }
    end

    travel_to Time.zone.local(2014, 10, 31) do # Friday
      metrics = Metrics.signups_per_day

      expect(metrics[0][:count]).to eq(3)
      expect(metrics[1][:count]).to eq(0)
      expect(metrics[2][:count]).to eq(2)

      expect(metrics[0][:start]).to eq(Date.new(2014, 10, 25))
      expect(metrics[1][:start]).to eq(Date.new(2014, 10, 26))
      expect(metrics.length).to eq(7)
    end
  end

  it "returns count of users who were last active x weeks ago" do
    mark_active = Proc.new { |a| a.update_single_attribute(:last_activity_at, Time.current) }
    accounts = nil
    travel_to Time.zone.local(2014, 4, 1) do
      accounts = 6.times.map { create(:account) }
      mark_active.call(accounts[0])
    end

    travel_to Time.zone.local(2014, 8, 11) do
      accounts[1..3].each(&mark_active)
    end

    travel_to Time.zone.local(2014, 8, 26) do
      accounts[4..5].each(&mark_active)
    end

    travel_to Time.zone.local(2014, 10, 31) do # Friday
      metrics = Metrics.churn_per_week

      expect(metrics[0][:count]).to eq(1)
      expect(metrics[1][:count]).to eq(3)
      expect(metrics[2][:count]).to eq(0)
      expect(metrics[3][:count]).to eq(2)

      expect(metrics[0][:start]).to eq(-Date::Infinity.new)
      expect(metrics[1][:start]).to eq(Date.new(2014, 8, 11))
      expect(metrics[2][:start]).to eq(Date.new(2014, 8, 18))
      expect(metrics.length).to eq(13)
    end
  end

  it "returns count of users who were last active x days ago" do
    mark_active = Proc.new { |a| a.update_single_attribute(:last_activity_at, Time.current) }
    accounts = nil
    travel_to Time.zone.local(2014, 10, 24) do
      accounts = 6.times.map { create(:account) }
      mark_active.call(accounts[0])
    end

    travel_to Time.zone.local(2014, 10, 25) do
      accounts[1..3].each(&mark_active)
    end

    travel_to Time.zone.local(2014, 10, 27) do
      accounts[4..5].each(&mark_active)
    end

    travel_to Time.zone.local(2014, 10, 31) do # Friday
      metrics = Metrics.churn_per_day

      expect(metrics[0][:count]).to eq(3)
      expect(metrics[1][:count]).to eq(0)
      expect(metrics[2][:count]).to eq(2)

      expect(metrics[0][:start]).to eq(Date.new(2014, 10, 25))
      expect(metrics[1][:start]).to eq(Date.new(2014, 10, 26))
      expect(metrics.length).to eq(7)
    end
  end
end
