class Van < ApplicationRecord
  belongs_to :mestre

  def detalhe(row)
    linha = row.split('|')
    self.cnpj = linha[2]
    self.nome = linha[3]&.strip
  end
end