class CreateDriverApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :driver_applications do |t|
      t.references :snap_application, foreign_key: true, null: false
      t.string :encrypted_user_id, null: false
      t.string :encrypted_user_id_iv, null: false
      t.string :encrypted_password, null: false
      t.string :encrypted_password_iv, null: false
      t.string :encrypted_secret_question_1_answer, null: false
      t.string :encrypted_secret_question_1_answer_iv, null: false
      t.string :encrypted_secret_question_2_answer, null: false
      t.string :encrypted_secret_question_2_answer_iv, null: false

      t.timestamps
    end
  end
end
