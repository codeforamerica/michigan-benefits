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

      expect(metrics[-1][:count]).to eq(3)
      expect(metrics[-2][:count]).to eq(0)
      expect(metrics[-3][:count]).to eq(2)

      expect(metrics[-1][:start]).to eq(Time.current - 12.weeks)
      expect(metrics[-2][:start]).to eq(Time.current - 11.weeks)
      expect(metrics.length).to eq(12)
    end
  end

  it "returns signups per day in the last week" do
    travel_to Time.zone.local(2014, 10, 23) do
      1.times { create(:account) }
    end

    travel_to Time.zone.local(2014, 10, 24) do
      3.times { create(:account) }
    end

    travel_to Time.zone.local(2014, 10, 26) do
      2.times { create(:account) }
    end

    travel_to Time.zone.local(2014, 10, 31) do # Friday
      metrics = Metrics.signups_per_day

      expect(metrics[-1][:count]).to eq(3)
      expect(metrics[-2][:count]).to eq(0)
      expect(metrics[-3][:count]).to eq(2)

      expect(metrics[-1][:start]).to eq(Time.current - 7.days)
      expect(metrics[-2][:start]).to eq(Time.current - 6.days)
      expect(metrics.length).to eq(7)
    end
  end

  let(:mark_active) do
    Proc.new { |a| a.update_attribute(:last_activity_at, Time.current) }
  end

  it "returns count of lapsed users" do
    accounts = nil
    travel_to Time.zone.local(2014, 4, 1) do
      accounts = 3.times.map { create(:account) }
      # accounts[0] never active
      mark_active.call(accounts[1])
    end

    travel_to Time.zone.local(2014, 8, 15) do
      mark_active.call(accounts[2])
    end

    travel_to Time.zone.local(2014, 10, 31) do # Friday
      metrics = Metrics.lapsed

      expect(metrics[:count]).to eq(2)

      expect(metrics[:start]).to eq(-Date::Infinity.new)
    end
  end

  it "returns count of users who were last active x weeks ago" do
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

      expect(metrics[-1][:count]).to eq(3)
      expect(metrics[-2][:count]).to eq(0)
      expect(metrics[-3][:count]).to eq(2)

      expect(metrics[-1][:start]).to eq(Time.current - 12.weeks)
      expect(metrics[-2][:start]).to eq(Time.current - 11.weeks)
      expect(metrics.length).to eq(12)
    end
  end

  it "returns count of users who were last active x days ago" do
    accounts = nil
    travel_to Time.zone.local(2014, 10, 23) do
      accounts = 6.times.map { create(:account) }
      mark_active.call(accounts[0])
    end

    travel_to Time.zone.local(2014, 10, 24) do
      accounts[1..3].each(&mark_active)
    end

    travel_to Time.zone.local(2014, 10, 26) do
      accounts[4..5].each(&mark_active)
    end

    travel_to Time.zone.local(2014, 10, 31) do # Friday
      metrics = Metrics.churn_per_day

      expect(metrics[-1][:count]).to eq(3)
      expect(metrics[-2][:count]).to eq(0)
      expect(metrics[-3][:count]).to eq(2)

      expect(metrics[-1][:start]).to eq(Time.current - 7.days)
      expect(metrics[-2][:start]).to eq(Time.current - 6.days)
      expect(metrics.length).to eq(7)
    end
  end
end
