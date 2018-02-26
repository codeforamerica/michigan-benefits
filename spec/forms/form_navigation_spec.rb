require "rails_helper"

RSpec.describe FormNavigation do
  before(:each) do
    class SkippedController
      def self.skip?(_)
        true
      end

      def current_application; end
    end

    class NonSkippedController
      def self.skip?(_)
        false
      end

      def current_application; end
    end

    class FirstMainController < NonSkippedController; end
    class SecondMainController < NonSkippedController; end
    class ThirdMainController < NonSkippedController; end
    class FirstOffMainController < NonSkippedController; end

    stub_const("FormNavigation::MAIN",
                 "Foo" => [
                   FirstMainController,
                   SecondMainController,
                   ThirdMainController,
                 ])

    stub_const("FormNavigation::OFF_MAIN",
                 "Bar" => [
                   FirstOffMainController,
                 ])
  end

  describe ".all" do
    it "returns all of controllers for which routes should be created" do
      expect(FormNavigation.all).to match_array(
        [
          FirstMainController,
          SecondMainController,
          ThirdMainController,
          FirstOffMainController,
        ],
      )
    end
  end

  describe ".form_controllers_with_groupings" do
    it "returns the main flow, including groupings" do
      expect(FormNavigation.form_controllers_with_groupings).to be_a(Hash)
      expect(FormNavigation.form_controllers_with_groupings).to eq(FormNavigation::MAIN)
    end
  end

  describe ".forms" do
    it "returns the main flow, not including groupings" do
      expect(FormNavigation.form_controllers).to match_array(
        [
          FirstMainController,
          SecondMainController,
          ThirdMainController,
        ],
      )
    end
  end

  describe "#next" do
    context "when current controller is second to last or before" do
      before do
        allow(SecondMainController).to receive(:skip?) { true }
      end

      it "returns numeric index for next non-skipped controller in main flow" do
        navigation = FormNavigation.new(FirstMainController.new)
        expect(navigation.next).to eq(ThirdMainController)
      end
    end

    context "when current controller is the last to not be skipped" do
      it "returns nil" do
        navigation = FormNavigation.new(ThirdMainController.new)
        expect(navigation.next).to be_nil
      end
    end

    context "when current controller is not in main list" do
      it "returns nil" do
        navigation = FormNavigation.new("boop")
        expect(navigation.next).to be_nil
      end
    end
  end

  describe "#previous" do
    context "when current form is second or after" do
      before do
        allow(SecondMainController).to receive(:skip?) { true }
      end

      it "returns numeric index for preceding non-skipped controller in main flow" do
        navigation = FormNavigation.new(ThirdMainController.new)
        expect(navigation.previous).to eq(FirstMainController)
      end
    end

    context "when current controller is the first" do
      it "returns nil" do
        navigation = FormNavigation.new(FirstMainController.new)
        expect(navigation.previous).to be_nil
      end
    end

    context "when current controller is not in main list" do
      it "returns nil" do
        navigation = FormNavigation.new("boop")
        expect(navigation.previous).to be_nil
      end
    end
  end

  describe "#index" do
    it "returns the numeric index in the main flow for a given step" do
      navigation = FormNavigation.new(SecondMainController.new)
      expect(navigation.index).to eq(1)
    end
  end
end
