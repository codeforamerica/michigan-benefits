module Integrated
  class UploadPaperworkController < FormsController
    def self.skip?(application)
      application.navigator.upload_paperwork?
    end

    def edit
      @form = form_class.new(paperwork: current_application.paperwork)
    end

    private

    def form_params
      params.fetch(:form, {}).permit(paperwork: [])
    end

    def update_models
      current_application.update!(paperwork: @form.paperwork || [])
    end
  end
end
