FactoryBot.define do
  factory :mestre do
    cod_ver_rcad { "MyString" }
    cod_ver { "MyString" }
    cod_fin { 1 }
    uf_fisco { "MyString" }
    cnpj { "MyString" }
    nome { "MyString" }
    dt_ini { "2025-04-15" }
    dt_fin { "2025-04-15" }
    tp_amb { 1 }
    mes_val { "MyString" }
    uf { "MyString" }
    nome_resp { "MyString" }
    fone { "MyString" }
    email { "MyString" }
    nacional_1100 { false }
    comex_1100 { false }
    nacional_1500 { false }
    comex_1500 { false }
    sha256 { "MyString" }
    blob { "" }
  end
end
