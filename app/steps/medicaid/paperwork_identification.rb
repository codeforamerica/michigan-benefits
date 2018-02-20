module Medicaid
  class PaperworkIdentification < Step
    step_attributes(:has_picture_id_for_everyone)

    validates_presence_of :has_picture_id_for_everyone
  end
end
