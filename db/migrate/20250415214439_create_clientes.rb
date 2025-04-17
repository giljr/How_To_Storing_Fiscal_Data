class CreateClientes < ActiveRecord::Migration[8.0]
  def change
    create_table :clientes do |t|
      t.string :cnpj
      t.string :cpf
      t.date :dt_credenciamento
      t.references :mestre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
