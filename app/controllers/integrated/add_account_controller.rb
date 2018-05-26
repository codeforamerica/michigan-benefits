module Integrated
  class AddAccountController < FormsController
    def previous_path(*args)
      overview_path(*args)
    end

    def next_path
      overview_path
    end

    def overview_path(*args)
      accounts_overview_sections_path(*args)
    end

    helper_method :members

    def members
      current_application.members
    end

    private

    def assign_attributes_to_form
      @form = form_class.new(form_params.merge(valid_members: members))
    end

    def update_models
      Account.create!(params_for(:account))
    end
  end
end
