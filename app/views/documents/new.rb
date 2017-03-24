class Views::Documents::New < Views::Base
  needs :document

  def content
    content_for :header_title, "Submit Documents"

    form_for document do |f|
      div class: "slab slab--white" do
        h2 "Select a file to upload", id: "file-label"
      end

      div class: "slab slab--white" do
        div class: "card" do
          f.file_field :file, 'aria-labelledby' => 'file-label'
        end
      end

      div class: "slab slab--white" do
        link_to "Go back", documents_path, class: "button button--transparent"

        button type: "submit", class: "button button--cta" do
          text "Upload"
          i class: "button__icon icon-file_upload"
        end
      end
    end
  end
end
