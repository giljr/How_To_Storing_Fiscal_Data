class CreateContadorRegistros < ActiveRecord::Migration[8.0]
  def change
    create_table :contador_registros do |t|
      t.integer :qtd_b
      t.integer :qtd_c
      t.integer :qtd_d
      t.integer :qtd_e
      t.integer :qtd_f
      t.integer :qtd_g
      t.integer :qtd_h
      t.references :mestre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
