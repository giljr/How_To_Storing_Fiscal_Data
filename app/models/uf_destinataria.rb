class UfDestinataria < ApplicationRecord
belongs_to :mestre

  def detalhe(row)
    linha = row.split('|')
    self.uf   = linha[2]
    self.qtd  = linha[3].to_i
  end

end