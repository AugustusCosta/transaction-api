class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.string :transaction_code
      t.integer :credited_account_id
      t.integer :debited_account_id
      t.boolean :reversed, default: false

      t.timestamps
    end
  end
end
