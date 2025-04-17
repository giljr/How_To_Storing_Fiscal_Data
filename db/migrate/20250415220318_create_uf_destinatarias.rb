class CreateUfDestinatarias < ActiveRecord::Migration[8.0]
  def change
    create_table :uf_destinatarias do |t|
      t.string :uf
      t.integer :qtd
      t.references :mestre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
