module Integrated
  class IntroduceYourselfController < FormsController
    def update_models
      member_data = member_params.merge(
        relationship: "primary",
        requesting_food: "yes",
        requesting_healthcare: "yes",
        buy_and_prepare_food_together: "yes",
      )
      member_data.merge!(combined_birthday_fields(
                           day: member_data.delete(:birthday_day),
                           month: member_data.delete(:birthday_month),
                           year: member_data.delete(:birthday_year),
      ))
      if current_application.primary_member
        current_application.primary_member.update(member_data)
      else
        current_application.members.create(member_data)
      end
      current_application.update(application_params)
    end

    private

    def existing_attributes
      if current_application.primary_member
        attributes = current_application.attributes.merge(current_application.primary_member.attributes)
        %i[year month day].each do |sym|
          attributes["birthday_#{sym}"] = current_application.primary_member.birthday.try(sym)
        end
        HashWithIndifferentAccess.new(attributes)
      else
        {}
      end
    end
  end
end
