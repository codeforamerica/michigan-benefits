# Place idempotent, one off execution things here so they get auto-ran on deploy
namespace :one_offs do
  desc "runs all one_offs, remove things from here after they are deployed"
  task run_all: :environment do
    # Make old employments (SNAP + Medicaid Flows) polymorphic
    Employment.where(application_member_type: nil).find_each do |member|
      member.update(
        application_member_type: "Member",
        application_member_id: member.member_id,
      )
    end

    # Create empty employments for deprecated job_count
    HouseholdMember.where.not(job_count: nil).find_each do |member|
      unless member.job_count == member.employments.count
        member.job_count.times do
          member.employments << Employment.new
        end
        member.job_count = nil
        member.save
      end
    end

    # Reset and backfill cache counter for employments
    HouseholdMember.reset_column_information
    HouseholdMember.pluck(:id).each do |id|
      HouseholdMember.reset_counters id, :employments
    end
  end
end
