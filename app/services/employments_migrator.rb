class EmploymentsMigrator
  def run
    ActiveRecord::Base.transaction do
      members_with_jobs.each do |member|
        last_employment_index = member.employed_employer_names.count - 1
        employment_indices = (0..last_employment_index).to_a
        employments = employment_indices.map do |i|
          Employment.new(
            employer_name: member.employed_employer_names[i],
            payment_frequency: member.employed_payment_frequency[i],
            pay_quantity: member.employed_pay_quantities[i],
          )
        end

        member.update!(employments: employments)
      end
    end
  end

  private

  def members_with_jobs
    Member.where.not(employed_employer_names: nil)
  end
end
