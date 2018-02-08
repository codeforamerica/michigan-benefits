module Integrated
  class FormsController < ApplicationController
    layout "form"

    helper_method :application_title

    def application_title
      "Food + Health Assistance"
    end
  end
end
