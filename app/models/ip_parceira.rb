class IpParceira < ApplicationRecord
  belongs_to :mestre

  def detalhe(row)
    linha = row.split('|')
    self.cnpj        = linha[2]
    self.nome        = linha[3]&.strip
    self.nome_resp   = linha[4]&.strip
    self.fone        = linha[5]
    self.email       = linha[6]&.strip
  end
end