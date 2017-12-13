module MiBridges
  class Driver
    class MoreAboutSelfEmploymentPage < FillInAndClickNextPage
      def self.title
        /More About (.*)'s Self-Employment/
      end

      delegate :members, to: :snap_application

      def fill_in_required_fields
        members.each do |member|
          fill_in_all_programs_for(member)
          fill_in_fap_program_benefits_for(member)
        end
      end

      private

      def fill_in_all_programs_for(member)
        name = member.mi_bridges_formatted_name
        question_type = "What type of self-employment does #{name} have?"
        select "Other", from: question_type
        question_other = "If self-employment type is Other, "\
          "what type of work does #{name} do?"
        fill_in question_other, with: member.self_employed_profession
      end

      def fill_in_fap_program_benefits_for(member)
        name = member.mi_bridges_formatted_name
        question_income = "What is the gross monthly income amount "\
          "from #{name}'s self-employment before any expenses?"
        fill_in question_income, with: member.self_employed_monthly_income
        question_expenses = "How much are #{name}'s business "\
          "expenses each month?"
        fill_in question_expenses, with: member.self_employed_monthly_expenses
      end
    end
  end
end
