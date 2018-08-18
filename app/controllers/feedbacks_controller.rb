class FeedbacksController < ApplicationController
  def create
    @form = FeedbackForm.new(form_params)

    respond_to do |format|
      if @form.valid? && current_application&.update(form_params)
        format.json { render json: {}, status: :created }
      else
        format.json { render json: { errors: @form.errors.messages }, status: :unprocessable_entity }
      end
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
