class CreateAccountHierarchies < ActiveRecord::Migration[5.0]
  def change
    create_table :account_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :account_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "account_anc_desc_idx"

    add_index :account_hierarchies, [:descendant_id],
      name: "account_desc_idx"
  end
end
