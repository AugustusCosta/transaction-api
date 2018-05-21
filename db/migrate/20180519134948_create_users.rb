class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.integer :legal_person_id
      t.integer :physical_person_id
      t.integer :user_type

      t.timestamps
    end
  end
end
