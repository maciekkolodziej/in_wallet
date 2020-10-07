class CreateTransaction < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions, id: :uuid do |t|
      t.references :virtual_card, type: :uuid

      t.string :description, null: false
      t.decimal :balance_before, null: false
      t.decimal :amount, null: false
      t.decimal :balance_after, null: false
      t.timestamps

      t.foreign_key :virtual_cards
    end
  end
end
