require "rails_helper"

describe Step do
  describe ".find" do
    specify { expect(Step.find("introduction-introduce-yourself", App.create)).to be_an_instance_of IntroductionIntroduceYourself }
  end

  describe "#initialize" do
    let!(:app) { App.create(phone_number: "415-867-5309") }
    let!(:applicant) { app.applicant }

    it "assigns fields from the app" do
      applicant.update(first_name: "Alice")
      step = IntroductionIntroduceYourself.new(app.reload)

      expect(step.first_name).to eq "Alice"
      expect(step.last_name).to eq nil
    end
  end

  describe "#to_param" do
    specify { expect(IntroductionIntroduceYourself.to_param).to eq "introduction-introduce-yourself" }
    specify { expect(IntroductionIntroduceYourself.new(App.create).to_param).to eq "introduction-introduce-yourself" }
  end

  describe "#update" do
    let!(:app) { App.create }
    let!(:applicant) { app.applicant }
    let(:step) { IntroductionIntroduceYourself.new(app) }

    context "when everything is valid" do
      it "updates the app" do
        step.update(first_name: "Alice", last_name: "Aardvark")

        expect(step).to be_valid
        expect(app.reload.applicant.first_name).to eq "Alice"
        expect(app.reload.applicant.last_name).to eq "Aardvark"
      end
    end

    context "when some fields are invalid" do
      it "does not update the app" do
        app.applicant.update! first_name: "Alice", last_name: "Aardvark"

        step.update({ first_name: "Billy", last_name: nil })

        expect(step).not_to be_valid
        expect(app.reload.applicant.first_name).to eq "Alice"
        expect(app.reload.applicant.last_name).to eq "Aardvark"
      end
    end
  end
end
