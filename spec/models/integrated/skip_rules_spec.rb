require "spec_helper"
require "rspec/rails"
require_relative "../../../app/models/common_application"
require_relative "../../../app/models/skip_rules"

RSpec.describe SkipRules do
  describe "#single_member_only" do
    context "with multi-member household" do
      it "returns true" do
        application = instance_double(CommonApplication, single_member_household?: false)

        expect(SkipRules.single_member_only(application)).to eq(true)
      end
    end

    context "with single-member household" do
      it "returns false" do
        application = instance_double(CommonApplication, single_member_household?: true)

        expect(SkipRules.single_member_only(application)).to be_falsey
      end
    end
  end

  describe "#multi_member_only" do
    context "with single-member household" do
      it "returns true" do
        application = instance_double(CommonApplication, single_member_household?: true)

        expect(SkipRules.multi_member_only(application)).to eq(true)
      end
    end

    context "with multi-member household" do
      it "returns false" do
        application = instance_double(CommonApplication, single_member_household?: false)

        expect(SkipRules.multi_member_only(application)).to be_falsey
      end
    end
  end

  describe "#must_be_applying_for_healthcare" do
    context "when not applying for healthcare" do
      it "returns true" do
        application = instance_double(CommonApplication, applying_for_healthcare?: false)

        expect(SkipRules.must_be_applying_for_healthcare(application)).to eq(true)
      end
    end

    context "when applying for healthcare" do
      it "returns false" do
        application = instance_double(CommonApplication, applying_for_healthcare?: true)

        expect(SkipRules.must_be_applying_for_healthcare(application)).to be_falsey
      end
    end
  end

  describe "#must_not_be_applying_for_healthcare" do
    context "when applying for healthcare" do
      it "returns true" do
        application = instance_double(CommonApplication, applying_for_healthcare?: true)

        expect(SkipRules.must_not_be_applying_for_healthcare(application)).to eq(true)
      end
    end

    context "when not applying for healthcare" do
      it "returns false" do
        application = instance_double(CommonApplication, applying_for_healthcare?: false)

        expect(SkipRules.must_not_be_applying_for_healthcare(application)).to be_falsey
      end
    end
  end
end
