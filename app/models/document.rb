# frozen_string_literal: true

class Document < ApplicationRecord
  belongs_to :app, inverse_of: :documents

  has_attached_file :file, styles: { thumb: '100x100#' }

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

  before_post_process :skip_processing_for_non_images

  def image?
    !!file_content_type&.match(/^image/)
  end

  def skip_processing_for_non_images
    image?
  end
end
