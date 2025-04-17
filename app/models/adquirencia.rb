class Adquirencia < ApplicationRecord
  belongs_to :mestre

  def detalhe(row)
    linha = row.split('|')
    self.cnpj_adqui = linha[2]
  end
end