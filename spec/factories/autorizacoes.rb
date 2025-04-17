FactoryBot.define do
  factory :autorizacao do
    tp_autoriz { 1 }
    cnpj { "MyString" }
    tp_transac { 1 }
    dt_ini_aut { "2025-04-15" }
    dt_fim_aut { "2025-04-15" }
    mestre { nil }
  end
end
