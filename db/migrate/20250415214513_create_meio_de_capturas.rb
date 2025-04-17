class CreateMeioDeCapturas < ActiveRecord::Migration[8.0]
  def change
    create_table :meio_de_capturas do |t|
      t.integer :tipo_tecn
      t.integer :term_prop
      t.string :marca
      t.references :mestre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
