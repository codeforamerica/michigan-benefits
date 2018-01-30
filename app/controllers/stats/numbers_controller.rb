module Stats
  class NumbersController < ApplicationController
    def index
      @snap_count = SnapApplication.count
      @medicaid_count = MedicaidApplication.count

      render :index
    end
  end
end
