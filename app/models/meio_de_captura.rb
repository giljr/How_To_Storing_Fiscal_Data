class MeioDeCaptura < ApplicationRecord
  belongs_to :mestre

  def detalhe(row)
    linha = row.split('|')
    self.tipo_tecn = linha[2]
    self.term_prop = linha[3]
    self.marca     = linha[4]&.strip
  end
end