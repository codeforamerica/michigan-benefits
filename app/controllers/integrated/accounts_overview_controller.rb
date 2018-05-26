module Integrated
  class AccountsOverviewController < FormsController
    def self.skip?(application)
      !application.less_than_threshold_in_accounts_no?
    end

    def form_class
      NullStep
    end
  end
end
