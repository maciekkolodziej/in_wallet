class CreateVirtualCard < ActiveRecord::Migration[5.2]
  def change
    create_table :virtual_cards, id: :uuid do |t|
      t.string :name, null: false
      t.string :number, limit: 16, null: false
      t.string :encrypted_cvv

      t.decimal :limit, null: false, default: 0
      t.decimal :balance, null: false, default: 0

      t.timestamps null: false
    end
  end
end
