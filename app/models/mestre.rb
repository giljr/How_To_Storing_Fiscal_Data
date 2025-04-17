class Mestre < ApplicationRecord
  has_many :clientes
  has_many :vans
  has_many :meio_de_capturas
  has_many :ip_parceiras
  has_many :adquirencias
  has_many :uf_destinatarias
  has_many :autorizacoes

  def detalhe(row)
    linha = row.split('|')
    self.cod_ver_rcad      = linha[2]
    self.cod_ver           = linha[3]
    self.cod_fin           = linha[4]
    self.uf_fisco          = linha[5]
    self.cnpj              = linha[6]
    self.nome              = linha[7]&.strip
    self.dt_ini            = parse_data(linha[8])
    self.dt_fin            = parse_data(linha[9])
    self.tp_amb            = linha[10]
    self.mes_val           = linha[11]
    self.uf                = linha[12]
    self.nome_resp         = linha[13]&.strip
    self.fone              = linha[14]
    self.email             = linha[15]&.strip
    self.nacional_1100     = linha[16] == '1'
    self.comex_1100        = linha[17] == '1'
    self.nacional_1500     = linha[18] == '1'
    self.comex_1500        = linha[19] == '1'
    self.sha256            = linha[20]
  end

  private

  def parse_data(str)
    Date.strptime(str, '%Y%m%d') rescue nil
  end
end