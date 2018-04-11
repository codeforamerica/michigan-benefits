module Integrated
  class HowManyJobsController < MultipleMembersController
    def self.skip?(application)
      application.single_member_household? && !application.navigator.current_job?
    end

    def members_to_update
      current_application.members.each do |member|
        if member.job_count.nil?
          member.job_count = member.primary_member? && current_application.navigator.current_job? ? 1 : 0
        end
      end
    end
  end
end
