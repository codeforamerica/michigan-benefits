require "rails_helper"

describe GateKeeper do
  describe ".feature_enabled?"

  describe ".demo_environment?" do
    context "when DEMO_SITE is true" do
      it "returns true" do
        with_modified_env DEMO_SITE: "true" do
          expect(GateKeeper.demo_environment?).to eq(true)
        end
      end
    end

    context "when DEMO_SITE is unset" do
      context "in staging environment" do
        before do
          allow(Rails).to receive(:env) { "staging".inquiry }
        end

        it "returns true" do
          expect(GateKeeper.demo_environment?).to eq(true)
        end
      end

      context "in test environment" do
        it "returns false" do
          expect(GateKeeper.demo_environment?).to eq(false)
        end
      end

      context "in development environment" do
        before do
          allow(Rails).to receive(:env) { "development".inquiry }
        end

        it "returns false" do
          expect(GateKeeper.demo_environment?).to eq(false)
        end
      end

      context "in production environment" do
        before do
          allow(Rails).to receive(:env) { "production".inquiry }
        end

        it "returns false" do
          expect(GateKeeper.demo_environment?).to eq(false)
        end
      end
    end
  end
end
