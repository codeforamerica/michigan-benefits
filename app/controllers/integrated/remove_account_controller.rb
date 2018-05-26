module Integrated
  class RemoveAccountController < FormsController
    def update_models
      flash[:notice] = if account && account.destroy
                         "Removed the account."
                       else
                         "Could not remove account."
                       end
    end

    def previous_path(*_args)
      overview_path
    end

    def next_path
      overview_path
    end

    def overview_path
      accounts_overview_sections_path
    end

    def account
      if params_for(:account)[:account_id].present?
        current_application.accounts.find_by(id: params_for(:account)[:account_id])
      end
    end

    def form_class
      RemoveAccountForm
    end
  end
end
