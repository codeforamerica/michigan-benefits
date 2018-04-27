module Integrated
  class HowManyJobsController < FormsController
    def self.skip?(application)
      application.single_member_household? && !application.navigator.current_job?
    end

    def edit
      @form = form_class.new(members: current_application.members)
    end

    def update
      members_to_update = []

      @form = form_class.new(members: current_application.members)
      @form.members.each do |member|
        attrs = params.dig(:form, :members, member.to_param)
        if attrs.present?
          if member.employments.count != attrs[:employments_count].to_i
            members_to_update << {
              member: member,
              employments_count: attrs[:employments_count].to_i,
            }
          end
        end
      end

      ActiveRecord::Base.transaction do
        members_to_update.each do |member_attributes|
          member = member_attributes.fetch(:member)
          member.employments.each(&:destroy!)

          member_attributes.fetch(:employments_count).times do
            member.employments << Employment.new
          end
          member.save!
        end
      end

      redirect_to(next_path)
    end
  end
end
