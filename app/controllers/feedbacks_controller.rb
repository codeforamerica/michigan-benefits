class FeedbacksController < ApplicationController
  def create
    @form = FeedbackForm.new(form_params)

    if @form.valid?
      current_application&.update!(form_params)
    end

    respond_to do |format|
      format.js { render layout: false, locals: { feedback_form: @form } }
    end
  end

  def current_application
    CommonApplication.find_by(id: session[:current_application_id])
  end

  private

  def form_params
    params.require(:feedback_form).permit(:feedback_rating, :feedback_comments)
  end
end
