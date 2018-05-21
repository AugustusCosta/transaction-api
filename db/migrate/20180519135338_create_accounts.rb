class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.float :amount, default: 0
      t.integer :status, default: 0
      t.string :name
      t.integer :parent_id
      t.integer :user_id

      t.timestamps
    end
  end
end
