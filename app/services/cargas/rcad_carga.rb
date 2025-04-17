require 'fileutils'

module Cargas
  class RcadCarga
    def initialize
      @path        = Rails.application.config.rcad_path[:original]
      @processado  = Rails.application.config.rcad_path[:processados]
      @erro        = Rails.application.config.rcad_path[:erros]
      @colecoes    = {} # será preenchido dinamicamente
      start
    end

    def start
      logger = TTY::Logger.new
    
      Dir.entries(@path).each do |file|
        next unless file.upcase.end_with?('.TXT')
    
        ActiveRecord::Base.transaction do
          arquivo_path = File.join(@path, file)
          arquivo_original = File.open(arquivo_path, 'rb')
          arquivo = File.open(arquivo_path, 'r:iso-8859-1')
    
          logger.info "Carregando o arquivo #{file}..."
          spinner = TTY::Spinner.new("[:spinner] Carga do arquivo", format: :pulse_2)
          spinner.auto_spin
    
          inicializar_colecoes
    
          arquivo.each_line.with_index do |row, index|
            begin
              row.chomp!
              tipo = row.start_with?('|') ? row.split('|')[1] : nil
    
              if tipo == 'A'
                processar_mestre(row, arquivo_original)
              elsif @colecoes.key?(tipo)
                objeto = send(@colecoes[tipo][:metodo], row)
                @colecoes[tipo][:lista] << objeto
              end
            rescue => e
              log_erro(logger, spinner, "Erro na linha #{index + 1}", e)
              raise ActiveRecord::Rollback
            end
          end
    
          @colecoes.each_value do |col|
            col[:classe].import(col[:lista], validate: false, batch_size: 10_000)
          end
    
          FileUtils.mv(arquivo_path, @processado, force: true)
          spinner.success("(Finalizada)")
        rescue => e
          log_erro(logger, spinner, "Erro ao carregar o arquivo #{file}", e)
          raise ActiveRecord::Rollback
        end
      end
    end
    

    private

    def inicializar_colecoes
      @colecoes = {
        'B' => { lista: [], metodo: :cliente,            classe: Cliente },
        'C' => { lista: [], metodo: :van,                classe: Van },
        'D' => { lista: [], metodo: :meio_de_captura,    classe: MeioDeCaptura },
        'E' => { lista: [], metodo: :ip_parceira,        classe: IpParceira },
        'F' => { lista: [], metodo: :adquirencia,        classe: Adquirencia },
        'G' => { lista: [], metodo: :uf_destinataria,    classe: UfDestinataria },
        'H' => { lista: [], metodo: :autorizacao,        classe: Autorizacao },
        'Z' => { lista: [], metodo: :contador_registro,  classe: ContadorRegistro }
      }
    end

    def log_erro(logger, spinner, msg, exception)
      spinner.error("(Erro)")
      logger.error "#{msg}: #{exception.message}"
      logger.error exception.backtrace.take(5).join("\n")
    end

    def processar_mestre(row, arquivo_original)
      mestre       = Mestre.new
      mestre.blob  = arquivo_original.read
      mestre.detalhe(row)
      mestre.save!
      @mestre = mestre.id
    end

    def cliente(row)
      Cliente.new.tap do |c|
        c.detalhe(row)
        c.mestre_id = @mestre
      end
    end

    def van(row)
      Van.new.tap do |v|
        v.detalhe(row)
        v.mestre_id = @mestre
      end
    end

    def meio_de_captura(row)
      MeioDeCaptura.new.tap do |m|
        m.detalhe(row)
        m.mestre_id = @mestre
      end
    end

    def ip_parceira(row)
      IpParceira.new.tap do |ip|
        ip.detalhe(row)
        ip.mestre_id = @mestre
      end
    end

    def adquirencia(row)
      Adquirencia.new.tap do |a|
        a.detalhe(row)
        a.mestre_id = @mestre
      end
    end

    def uf_destinataria(row)
      UfDestinataria.new.tap do |u|
        u.detalhe(row)
        u.mestre_id = @mestre
      end
    end

    def autorizacao(row)
      Autorizacao.new.tap do |a|
        a.detalhe(row)
        a.mestre_id = @mestre
      end
    end

    def contador_registro(row)
      registro = ContadorRegistro.new
      registro.detalhe(row)
      registro.mestre_id = @mestre
      return registro
    end
    
  end
end
