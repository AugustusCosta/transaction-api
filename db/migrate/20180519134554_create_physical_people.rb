class CreatePhysicalPeople < ActiveRecord::Migration[5.2]
  def change
    create_table :physical_people do |t|
      t.integer :user_id
      t.string :cpf
      t.string :complete_name
      t.date :birth_date

      t.timestamps
    end
  end
end
