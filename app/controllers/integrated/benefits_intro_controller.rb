module Integrated
  class BenefitsIntroController < FormsController
    def form_class
      NullStep
    end

    def edit
      render :edit
    end
  end
end
