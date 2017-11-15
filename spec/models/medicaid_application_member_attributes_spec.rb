require "rails_helper"

RSpec.describe MedicaidApplicationMemberAttributes do
  describe "#to_h" do
    it "returns the member attributes as a hash" do
      member = create(
        :member,
        first_name: "First",
        last_name: "Last",
        birthday: Date.new(1991, 10, 18),
        sex: "male",
        married: true,
        caretaker_or_parent: true,
        in_college: true,
        spouse: create(:member, first_name: "Candy", last_name: "Crush"),
        ssn: "111223333",
        new_mom: true,
        requesting_health_insurance: true,
        citizen: true,
      )

      result = MedicaidApplicationMemberAttributes.new(
        member: member,
        position: "primary",
      ).to_h

      expect(result).to eq(
        primary_member_full_name: "First Last",
        primary_member_birthday: "10/18/1991",
        primary_member_sex_male: "Yes",
        primary_member_sex_female: nil,
        primary_member_married_yes: "Yes",
        primary_member_spouse_name: "Candy Crush",
        primary_member_caretaker_yes: "Yes",
        primary_member_in_college_yes: "Yes",
        primary_member_under_21_no: "Yes",
        primary_member_ssn_0: "1",
        primary_member_ssn_1: "1",
        primary_member_ssn_2: "1",
        primary_member_ssn_3: "2",
        primary_member_ssn_4: "2",
        primary_member_ssn_5: "3",
        primary_member_ssn_6: "3",
        primary_member_ssn_7: "3",
        primary_member_ssn_8: "3",
        primary_member_new_mom_yes: "Yes",
        primary_member_requesting_health_insurance_yes: "Yes",
        primary_member_citizen_yes: "Yes",
      )
    end

    context "nil birthday" do
      it "it does not return keys for age-related questions" do
        member = create(:member, birthday: nil)

        result = MedicaidApplicationMemberAttributes.new(
          member: member,
          position: "primary",
        ).to_h

        expect(result.keys).not_to include(
          %i[
            primary_member_birthday
            primary_member_under_21_no
            primary_member_under_21_yes
          ],
        )
      end
    end
  end
end
