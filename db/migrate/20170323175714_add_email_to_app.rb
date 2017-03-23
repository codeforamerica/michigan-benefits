class AddEmailToApp < ActiveRecord::Migration[5.0]
  class User < ApplicationRecord
    has_one :app
  end

  class App < ApplicationRecord
    belongs_to :user
  end

  def up
    add_column :apps, :email, :string

    User.find_each do |user|
      user.app.update! email: user.email
    end
  end

  def down
    remove_column :apps, :email, :string
  end
end
