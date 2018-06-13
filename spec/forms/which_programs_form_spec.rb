require "rails_helper"

RSpec.describe WhichProgramsForm do
  describe "validations" do
    context "without a selected program" do
      it "is invalid" do
        form = WhichProgramsForm.new(applying_for_food: "0")

        expect(form).not_to be_valid
        expect(form.errors[:programs]).to be_present
      end
    end

    context "with at least one selected program" do
      it "is valid" do
        form = WhichProgramsForm.new(applying_for_food: "1", applying_for_healthcare: "0")

        expect(form).to be_valid
      end
    end

    context "with a supported office" do
      it "is valid" do
        form = WhichProgramsForm.new(
          applying_for_food: "1",
          office_page: "clio",
        )

        expect(form).to be_valid
      end
    end

    context "with an unsupported office" do
      it "is invalid" do
        form = WhichProgramsForm.new(
          applying_for_food: "1",
          office_page: "banana",
        )

        expect(form).not_to be_valid
        expect(form.errors[:office_page]).to be_present
      end
    end
  end
end
