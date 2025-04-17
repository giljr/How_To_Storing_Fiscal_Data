class CreateIpParceiras < ActiveRecord::Migration[8.0]
  def change
    create_table :ip_parceiras do |t|
      t.string :cnpj
      t.string :nome
      t.string :nome_resp
      t.string :fone
      t.string :email
      t.references :mestre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
