require "rails_helper"

describe Step do
  describe ".find" do
    specify { expect(Step.find("introduce-yourself", App.new)).to be_an_instance_of IntroduceYourself }
  end

  describe "#initialize" do
    it "assigns fields from the app" do
      app = App.new(first_name: "Alice", phone_number: "415-867-5309")
      step = IntroduceYourself.new(app)

      expect(step.first_name).to eq "Alice"
      expect(step.last_name).to eq nil
    end
  end

  describe "#to_param" do
    specify { expect(IntroduceYourself.to_param).to eq "introduce-yourself" }
    specify { expect(IntroduceYourself.new(App.new).to_param).to eq "introduce-yourself" }
  end

  describe "#update" do
    let(:app) { App.new }
    let(:step) { IntroduceYourself.new(app) }

    context "when everything is valid" do
      it "updates the app" do
        step.update(first_name: "Alice", last_name: "Aardvark")

        expect(step).to be_valid
        expect(app.reload.first_name).to eq "Alice"
        expect(app.reload.last_name).to eq "Aardvark"
      end
    end

    context "when some fields are invalid" do
      it "does not update the app" do
        app.update! first_name: "Alice", last_name: "Aardvark"

        step.update({ first_name: "Billy", last_name: nil })

        expect(step).not_to be_valid
        expect(app.reload.first_name).to eq "Alice"
        expect(app.reload.last_name).to eq "Aardvark"
      end
    end
  end
end
