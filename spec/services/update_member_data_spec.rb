require "rails_helper"

RSpec.describe UpdateMemberData do
  describe "#run" do
    it "removes whitespace from first names and last names" do
      member = create(
        :member,
        first_name: " Ja Christa ",
        last_name: " Hart Young ",
        benefit_application: create(:snap_application),
      )

      UpdateMemberData.new.run
      member.reload

      expect(member.first_name).to eq "Ja Christa"
      expect(member.last_name).to eq "Hart Young"
    end

    it "sets nil other_income_types to be an empty array" do
      member = build(
        :member,
        other_income_types: nil,
        benefit_application: create(:snap_application),
      )
      member.save(validate: false)

      UpdateMemberData.new.run
      member.reload

      expect(member.other_income_types).to eq []
    end

    it "deals with invalid SSNs" do
      member = build(
        :member,
        encrypted_ssn: "W+n1fo2E6uEc48Nbysk+U71//HnCcflNDg==\n",
        encrypted_ssn_iv: "swMLioyO3rHox5tG\n",
        benefit_application: create(:snap_application),
      )
      member.save(validate: false)

      UpdateMemberData.new.run
      member.reload

      expect(member.ssn).to eq nil
      expect(member.encrypted_last_four_ssn).to eq nil
      expect(member.encrypted_last_four_ssn_iv).to eq nil
    end
  end
end
