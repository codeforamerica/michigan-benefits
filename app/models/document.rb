class Document < ActiveRecord::Base
  belongs_to :app, inverse_of: :documents

  has_attached_file :file
end
