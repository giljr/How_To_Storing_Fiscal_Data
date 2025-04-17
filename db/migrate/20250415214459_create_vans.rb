class CreateVans < ActiveRecord::Migration[8.0]
  def change
    create_table :vans do |t|
      t.string :cnpj
      t.string :nome
      t.references :mestre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
