module Integrated
  class HowManyJobsController < FormsController
    def self.skip?(application)
      application.single_member_household? && !application.navigator.current_job?
    end

    def edit
      job_counts = current_application.members.map do |member|
        member.employments.count
      end

      @form = form_class.new(members: current_application.members, job_counts: job_counts)
    end

    def update_models
      members_to_update = []

      application_params.fetch(:job_counts, []).each_with_index do |job_count, index|
        current_member = current_application.members[index]
        if current_member.employments.count != job_count.to_i
          members_to_update << { member: current_member, job_count: job_count.to_i }
        end
      end

      ActiveRecord::Base.transaction do
        members_to_update.each do |member_attributes|
          member = member_attributes.fetch(:member)
          member.employments.delete_all

          member_attributes.fetch(:job_count).times do
            member.employments << Employment.new
          end
          member.save!
        end
      end
    end
  end
end
