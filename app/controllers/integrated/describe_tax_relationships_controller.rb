module Integrated
  class DescribeTaxRelationshipsController < FormsController
    def self.skip?(application)
      application.single_member_household? ||
        application.primary_member.filing_taxes_next_year_no? ||
        !application.navigator.anyone_else_on_tax_return?
    end

    def edit
      @form = form_class.new(members: current_application.non_applicant_members)
    end

    def update
      @form = form_class.new(members: current_application.non_applicant_members)
      @form.members.each do |member|
        attrs = params.dig(:form, :members, member.to_param)
        if attrs.present?
          member.assign_attributes(attrs.permit(form_class.member_attributes))
        end
      end

      if @form.valid?
        ActiveRecord::Base.transaction { @form.members.each(&:save!) }
        redirect_to next_path
      else
        render :edit
      end
    end
  end
end
