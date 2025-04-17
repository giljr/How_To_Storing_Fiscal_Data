FactoryBot.define do
  factory :cliente do
    cnpj { "MyString" }
    cpf { "MyString" }
    dt_credenciamento { "2025-04-15" }
    mestre { nil }
  end
end
