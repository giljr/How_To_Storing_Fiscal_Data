class Autorizacao < ApplicationRecord
  belongs_to :mestre

  def detalhe(row)
    linha = row.split('|')
    self.tp_autoriz  = linha[2]
    self.cnpj        = linha[3]
    self.tp_transac  = linha[4]
    self.dt_ini_aut  = parse_data(linha[5])
    self.dt_fim_aut  = parse_data(linha[6])
  end

  private

  def parse_data(str)
    Date.strptime(str, '%Y%m%d') rescue nil
  end
end