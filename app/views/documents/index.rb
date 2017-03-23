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

    div class: "slab slab--white" do
      if documents.empty?
        p "No documents uploaded yet.", class: 'text--centered'
      end
    end

    div class: "slab slab--white" do
      link_to "Add a document", "#", class: "button button--cta"

      if documents.empty?
        link_to "I'll do this later",
          clear_sessions_path(redirect_to: confirmations_path),
          class: "button button--secondary-cta"
      end
    end
  end
end
