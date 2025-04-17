class CreateMestres < ActiveRecord::Migration[8.0]
  def change
    create_table :mestres do |t|
      t.string :cod_ver_rcad
      t.string :cod_ver
      t.integer :cod_fin
      t.string :uf_fisco
      t.string :cnpj
      t.string :nome
      t.date :dt_ini
      t.date :dt_fin
      t.integer :tp_amb
      t.string :mes_val
      t.string :uf
      t.string :nome_resp
      t.string :fone
      t.string :email
      t.boolean :nacional_1100
      t.boolean :comex_1100
      t.boolean :nacional_1500
      t.boolean :comex_1500
      t.string :sha256
      t.binary :blob

      t.timestamps
    end
  end
end
