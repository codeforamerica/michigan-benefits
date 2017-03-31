class Views::Steps::MaybeSubmitDocuments < Views::Base
  def content
    p <<~TEXT, class: 'text--small'
      You can do this later but submitting documents now will help the
      application process go faster.
    TEXT

    p <<~TEXT, class: 'text--small'
      If you're on a smartphone right now, you
      can take a picture and upload it.
    TEXT

    p <<~TEXT, class: "text--help"
      You may also share documents with MDHHS via pst mail or by delivering
      them to your local office in person.
    TEXT

    safety <<~TEXT
      MDHSS maintains strict security guidelines to protect the identities of our residents.
    TEXT

    footer class: 'form-card__footer' do
      link_to documents_path, class: "button button--cta" do
        text "Submit documents now"
        i class: "button__icon icon-arrow_forward"
      end

      link_to clear_sessions_path(redirect_to: confirmations_path), class: "button button--secondary-cta" do
        text "I’ll do it later"
        i class: "button__icon icon-arrow_forward"
      end
    end
  end
end
