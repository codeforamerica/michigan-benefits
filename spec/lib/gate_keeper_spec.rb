require "rails_helper"

describe GateKeeper do
  describe ".demo_environment?" do
    context "when APP_RELEASE_STAGE is 'staging'" do
      it "returns true" do
        with_modified_env APP_RELEASE_STAGE: "staging" do
          expect(GateKeeper.demo_environment?).to eq(true)
        end
      end
    end

    context "when APP_RELEASE_STAGE is production" do
      it "returns false" do
        with_modified_env APP_RELEASE_STAGE: "production" do
          expect(GateKeeper.demo_environment?).to eq(false)
        end
      end
    end

    context "when APP_RELEASE_STAGE is not set" do
      it "returns false" do
        expect(GateKeeper.demo_environment?).to eq(false)
        expect(GateKeeper.application_routing_environment).to eq("development")
      end
    end
  end

  describe ".production_environment?" do
    context "when APP_RELEASE_STAGE is 'staging'" do
      it "returns false" do
        with_modified_env APP_RELEASE_STAGE: "staging" do
          expect(GateKeeper.production_environment?).to eq(false)
        end
      end
    end

    context "when APP_RELEASE_STAGE is production" do
      context "and RAILS_ENV is production" do
        before do
          allow(Rails).to receive(:env) { "production".inquiry }
        end

        it "returns true" do
          with_modified_env APP_RELEASE_STAGE: "production" do
            expect(GateKeeper.production_environment?).to eq(true)
          end
        end
      end

      context "and RAILS_ENV is not production" do
        before do
          allow(Rails).to receive(:env) { "development".inquiry }
        end

        it "returns true" do
          with_modified_env APP_RELEASE_STAGE: "production" do
            expect(GateKeeper.production_environment?).to eq(false)
          end
        end
      end
    end

    context "when APP_RELEASE_STAGE is not set" do
      it "returns false" do
        expect(GateKeeper.production_environment?).to eq(false)
        expect(GateKeeper.application_routing_environment).to eq("development")
      end
    end
  end
end
