class UpdateMemberData
  def run
    update_members
  end

  private

  def update_members
    members.each do |member|
      begin
        member.first_name = member.first_name.strip if member.first_name
        member.last_name = member.last_name.strip if member.last_name

        if member.other_income_types.nil?
          member.other_income_types = []
        end

        member.save!
      rescue OpenSSL::Cipher::CipherError
        member.encrypted_last_four_ssn = nil
        member.encrypted_last_four_ssn_iv = nil
        member.encrypted_ssn = nil
        member.encrypted_ssn_iv = nil
        member.save!
      end
    end
  end

  def members
    Member.where(benefit_application_type: "SnapApplication")
  end
end
