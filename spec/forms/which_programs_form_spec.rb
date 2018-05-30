require "rails_helper"

RSpec.describe WhichProgramsForm do
  describe "validations" do
    context "invalid" do
      it "requires some answer" do
        form = WhichProgramsForm.new(applying_for_food: "0")

        expect(form).not_to be_valid
        expect(form.errors[:programs]).to be_present
      end
    end

    context "with at least one answer" do
      it "is valid" do
        form = WhichProgramsForm.new(applying_for_food: "1", applying_for_healthcare: "0")

        expect(form).to be_valid
      end
    end
  end
end
