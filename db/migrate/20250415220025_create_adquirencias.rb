class CreateAdquirencias < ActiveRecord::Migration[8.0]
  def change
    create_table :adquirencias do |t|
      t.string :cnpj_adqui
      t.references :mestre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
