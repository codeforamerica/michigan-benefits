# frozen_string_literal: true

class SsnMigrater
  def run
    Member.all.find_each do |member|
      update_last_four_ssn(member)
    end

    MedicaidApplication.all.find_each do |medicaid_app|
      update_last_four_ssn(medicaid_app)
    end
  end

  private

  def update_last_four_ssn(record)
    if record.ssn.present? && record.last_four_ssn.blank?
      last_four_ssn = record.ssn.last(4)
      record.update!(last_four_ssn: last_four_ssn)
    end
  end
end
