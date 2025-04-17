class DropUfDestinatariaTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :uf_destinataria, if_exists: true
  end
end
