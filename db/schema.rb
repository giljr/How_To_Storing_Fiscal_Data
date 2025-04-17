# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_17_183653) do
  create_table "adquirencias", force: :cascade do |t|
    t.string "cnpj_adqui"
    t.integer "mestre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mestre_id"], name: "index_adquirencias_on_mestre_id"
  end

  create_table "autorizacoes", force: :cascade do |t|
    t.integer "tp_autoriz"
    t.string "cnpj"
    t.integer "tp_transac"
    t.date "dt_ini_aut"
    t.date "dt_fim_aut"
    t.integer "mestre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mestre_id"], name: "index_autorizacoes_on_mestre_id"
  end

  create_table "clientes", force: :cascade do |t|
    t.string "cnpj"
    t.string "cpf"
    t.date "dt_credenciamento"
    t.integer "mestre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mestre_id"], name: "index_clientes_on_mestre_id"
  end

  create_table "contador_registros", force: :cascade do |t|
    t.integer "qtd_b"
    t.integer "qtd_c"
    t.integer "qtd_d"
    t.integer "qtd_e"
    t.integer "qtd_f"
    t.integer "qtd_g"
    t.integer "qtd_h"
    t.integer "mestre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mestre_id"], name: "index_contador_registros_on_mestre_id"
  end

  create_table "ip_parceiras", force: :cascade do |t|
    t.string "cnpj"
    t.string "nome"
    t.string "nome_resp"
    t.string "fone"
    t.string "email"
    t.integer "mestre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mestre_id"], name: "index_ip_parceiras_on_mestre_id"
  end

  create_table "meio_de_capturas", force: :cascade do |t|
    t.integer "tipo_tecn"
    t.integer "term_prop"
    t.string "marca"
    t.integer "mestre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mestre_id"], name: "index_meio_de_capturas_on_mestre_id"
  end

  create_table "mestres", force: :cascade do |t|
    t.string "cod_ver_rcad"
    t.string "cod_ver"
    t.integer "cod_fin"
    t.string "uf_fisco"
    t.string "cnpj"
    t.string "nome"
    t.date "dt_ini"
    t.date "dt_fin"
    t.integer "tp_amb"
    t.string "mes_val"
    t.string "uf"
    t.string "nome_resp"
    t.string "fone"
    t.string "email"
    t.boolean "nacional_1100"
    t.boolean "comex_1100"
    t.boolean "nacional_1500"
    t.boolean "comex_1500"
    t.string "sha256"
    t.binary "blob"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uf_destinatarias", force: :cascade do |t|
    t.string "uf"
    t.integer "qtd"
    t.integer "mestre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mestre_id"], name: "index_uf_destinatarias_on_mestre_id"
  end

  create_table "vans", force: :cascade do |t|
    t.string "cnpj"
    t.string "nome"
    t.integer "mestre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mestre_id"], name: "index_vans_on_mestre_id"
  end

  add_foreign_key "adquirencias", "mestres"
  add_foreign_key "autorizacoes", "mestres"
  add_foreign_key "clientes", "mestres"
  add_foreign_key "contador_registros", "mestres"
  add_foreign_key "ip_parceiras", "mestres"
  add_foreign_key "meio_de_capturas", "mestres"
  add_foreign_key "uf_destinatarias", "mestres"
  add_foreign_key "vans", "mestres"
end
