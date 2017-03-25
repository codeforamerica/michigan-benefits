class Views::Documents::Index < Views::Base
  needs :documents

  def content
    content_for :header_title, "Submit Documents"

    div class: "slab slab--white" do
      h2 "Submit documents"

      p <<-TEXT
        Based on your responses, you will need to submit the following documents:
      TEXT

      ul class: "list--bulleted" do
        li "Copy of your ID"
        li "Pay stubs (from the last 30 days)"
        li "Checking account statement"
        li "Rent receipt"
        li "Child care receipt"
      end

      p <<-TEXT, class: "text--help"
        You can also do this later if now is not a good time.
      TEXT
    end

    a class: "step-anchor", id: "attachments"
    div class: "slab slab--white" do
      if documents.empty?
        p "No documents uploaded yet.",
          class: 'text--centered'
      end

      div class: "slab--clearfix attachment-container" do
        documents.each do |document|
          div class: "attachment-preview" do
            link_to document.file.url, class: "attachment-preview__link", target: "_blank" do
              if document.image?
                image_tag document.file.url(:thumb)
              else
                # TODO placeholder image for non-images
                i class: "icon-photo", style: "font-size: 50px;"
              end
            end

            link_to "Delete",
              document_path(document),
              method: :delete,
              class: "attachment-preview__delete"
          end
        end
      end

      div class: "form-card__footer" do
        link_to "Add a document", new_document_path, class: "button button--cta"

        if documents.empty?
          link_to "I'll do this later",
            next_page,
            class: "button button--secondary-cta"
        else
          link_to next_page, class: "button button--secondary-cta" do
            text "I'm finished"
            i class: "icon-arrow_forward"
          end
        end
      end

    end
  end

  private

  def next_page
    clear_sessions_path(redirect_to: confirmations_path)
  end
end
