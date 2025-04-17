# app/models/cliente.rb

class Cliente < ApplicationRecord
  belongs_to :mestre

  def detalhe(row)
    linha = row.split('|')
    self.cnpj                 = linha[2]
    self.cpf                  = linha[3]
    self.dt_credenciamento    = parse_data(linha[4])
  end

  private

  def parse_data(str)
    Date.strptime(str, '%Y%m%d') rescue nil
  end
end
