class User < ApplicationRecord
  authenticates_with_sorcery!

  before_save { email.try(:downcase!) }

  has_one :app

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }

  def full_name
    if app.first_name.present? || app.last_name.present?
      [app.first_name, app.last_name].join(" ")
    else
      "Guest"
    end
  end
end
