class Document < ActiveRecord::Base
  belongs_to :app, inverse_of: :documents

  has_attached_file :file, styles: { thumb: "50x50>" }

  validates_attachment :file,
    content_type: {
      content_type: %w[
        application/pdf
        image/jpeg
        image/jpg
        image/png
      ]
    },
    size: { in: 0..10.megabytes }
end
