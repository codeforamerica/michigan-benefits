module MiBridges
  class Driver
    module Services
      class SubmitBuyFoodWith
        include Capybara::DSL

        def initialize(first_member:, second_member:)
          @first_member = first_member
          @second_member = second_member
        end

        def run
          within buy_food_with_section do
            find(:xpath, ".//*[@title='#{buy_food_with_option}']").click
          end
        end

        private

        attr_reader :first_member, :second_member

        def buy_food_with_section
          find("fieldset", text: buy_food_with_label)
        end

        def buy_food_with_label
          "Does #{first_name} usually buy and fix food with #{second_name}?"
        end

        def first_name
          first_member.mi_bridges_formatted_name
        end

        def second_name
          second_member.mi_bridges_formatted_name
        end

        def buy_food_with_option
          if second_member.buy_food_with?
            "Yes"
          else
            "No"
          end
        end
      end
    end
  end
end
