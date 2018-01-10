module CommonBenefitApplication
  extend ActiveSupport::Concern

  def last_emailed_office_at
    exports.emailed_office.succeeded.first&.completed_at
  end

  def signed_at_est
    signed_at&.
      in_time_zone("Eastern Time (US & Canada)")&.
      strftime("%m/%d/%Y at %I:%M%p %Z")
  end

  def primary_member
    members.order(:id).first || NullMember.new
  end

  def non_applicant_members
    members - [primary_member]
  end

  def display_name
    primary_member.display_name
  end

  def mailing_address
    addresses.where(mailing: true).first || NullAddress.new
  end

  def unstable_housing?
    !stable_housing?
  end
end
