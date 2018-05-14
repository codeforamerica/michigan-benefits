require "rails_helper"

RSpec.describe HowManyBabiesForm do
  describe "validations" do
    context "when baby count is 0" do
      it "is invalid" do
        form = HowManyBabiesForm.new(baby_count: 0)

        expect(form).not_to be_valid
        expect(form.errors[:baby_count]).to be_present
      end
    end

    context "when baby count is 1 or greater" do
      it "is valid" do
        form = HowManyBabiesForm.new(baby_count: 1)

        expect(form).to be_valid
      end
    end
  end
end
