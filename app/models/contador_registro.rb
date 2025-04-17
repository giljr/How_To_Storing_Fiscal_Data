class ContadorRegistro < ApplicationRecord
  belongs_to :mestre

  def detalhe(row)
    linha = row.split('|')
    self.qtd_b = linha[2].to_i
    self.qtd_c = linha[3].to_i
    self.qtd_d = linha[4].to_i
    self.qtd_e = linha[5].to_i
    self.qtd_f = linha[6].to_i
    self.qtd_g = linha[7].to_i
    self.qtd_h = linha[8].to_i
  end
end