class DocumentsController < ApplicationController
  layout 'step'

  def allowed
    {
      index: :member,
      new: :member,
      create: :member,
      destroy: :member
    }
  end

  def index
    @documents = current_app.documents.order(updated_at: :desc)
  end

  def new
    @document = current_app.documents.build
  end

  def create
    @document = current_app.documents.build(document_params)
    @document.save

    respond_with @document, location: redirect_path
  end

  def destroy
    @document = current_app.documents.find(params[:id])
    @document.destroy!

    redirect_to redirect_path
  end

  private

  def redirect_path
    documents_path(anchor: "attachments")
  end

  def document_params
    params.fetch(:document, {}).permit(:file)
  end
end
