# frozen_string_literal: true

class Views::Documents::New < Views::Base
  needs :document

  def content
    content_for :header_title, 'Submit Documents'
    content_for :back_path, documents_path

    div class: 'form-card' do
      form_for document do |f|
        header class: 'form-card__header' do
          h2 'Select a file to upload', id: 'file-label'
        end

        div class: 'form-card__content' do
          group_classes = 'form-group'
          group_classes += ' form-group--error' if errors?

          div class: group_classes do
            f.file_field :file, 'aria-labelledby' => 'file-label'

            if errors?
              p class: 'text--error' do
                i class: 'icon-warning'
                text error_messages.to_sentence
              end
            end
          end
        end

        footer class: 'form-card__footer' do
          button type: 'submit', class: 'button button--cta', disabled: true do
            text 'Upload'
            i class: 'button__icon icon-file_upload'
          end
        end
      end
    end

    content_for(:javascript) do
      javascript <<~JAVASCRIPT
        $("#document_file").change(function() {
          $("button[type='submit']").prop("disabled", false);
        });
      JAVASCRIPT
    end
  end

  private

  def error_messages
    messages = []

    if document.errors.key?(:file_content_type)
      messages << 'invalid file type: must be a JPG image or PDF'
    end

    messages << 'file is too large' if document.errors.key?(:file_file_size)

    messages = document.errors.full_messages if messages.empty?
    
    messages[0] = messages[0].capitalize

    messages
  end

  def errors?
    !document.errors.full_messages.empty?
  end
end
