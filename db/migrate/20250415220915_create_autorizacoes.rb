class CreateAutorizacoes < ActiveRecord::Migration[8.0]
  def change
    create_table :autorizacoes do |t|
      t.integer :tp_autoriz
      t.string :cnpj
      t.integer :tp_transac
      t.date :dt_ini_aut
      t.date :dt_fim_aut
      t.references :mestre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
