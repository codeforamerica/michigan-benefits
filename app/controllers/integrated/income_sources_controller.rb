module Integrated
  class IncomeSourcesController < MemberPerPageController
    def edit
      super

      Income::INCOME_SOURCES.each_key do |name|
        @form.assign_attribute(name, false)
      end
      current_member.incomes.each do |income|
        @form.assign_attribute(income.income_type, true)
      end
    end

    def update_models
      Income::INCOME_SOURCES.each_key do |key|
        if member_params[key] == "1"
          current_member.incomes.find_or_create_by(income_type: key)
        else
          current_member.incomes.where(income_type: key).destroy_all
        end
      end
    end
  end
end
