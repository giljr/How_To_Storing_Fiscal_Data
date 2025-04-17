# 🚀 Building a Robust RCAD File Upload Service with Rails 8

### _From Project Setup to Service Execution — A Step-by-Step Guide Using Ruby 3.3+, Transaction, FileUtils and Clean Architecture_

---

## 📘 About the Project

RCAD is a fiscal data initiative by Brazil's **CONFAZ** (National Council for Fiscal Policy), enabling structured communication across all 27 state tax departments. This project simulates a **real-world use case**, where you'll build a robust upload and parsing system using a clean, modular Rails 8 architecture.

Though the data used here is **fictitious**, the structure is suitable for production with minimal adjustments.

---

## 🎯 Objective

Create a Rails 8 app with:

- ✅ Ruby 3.3+ support
- ✅ Batch processing with `activerecord-import`
- ✅ Transaction safety and error rollback
- ✅ Modular parsing using `.detalhe(row)`
- ✅ Directory structure for organized file management
- ✅ API endpoint for triggering the service
- ✅ Ready for logging, testing, and extension

---

## 💡 Highlights

- 🔄 Batch import with `batch_size: 10000` for performance
- 🔒 Safe transactions using `ActiveRecord::Base.transaction`
- 🧱 Clean separation of logic using methods like `cliente(row)`
- 📁 Files moved after processing with `FileUtils.mv`

---

## 🚀 Let's Get Started!

> ⚠ If you get stuck, feel free to check the [GitHub repo](#).

---

### 1. Project Setup 🛠

```bash
rails new rcad_app --api
cd rcad_app
```
### 2. Add Required Gems 🧩

In your Gemfile:
```ruby
gem "activerecord-import"
gem "tty-logger"
gem "tty-spinner"
```
Then run:

    bundle install

### 3. Generate Models 🗃️
```ruby
rails g model MeioDeCaptura tipo_tecn:integer term_prop:integer marca:string mestre:references
rails g model IpParceira cnpj:string nome:string nome_resp:string fone:string email:string mestre:references
rails g model Adquirencia cnpj_adqui:string mestre:references
rails g model UfDestinataria uf:string qtd:integer mestre:references
rails g model Autorizacao tp_autoriz:integer cnpj:string tp_transac:integer dt_ini_aut:date dt_fim_aut:date mestre:references
rails g model ContadorRegistro qtd_b:integer qtd_c:integer qtd_d:integer qtd_e:integer qtd_f:integer qtd_g:integer qtd_h:integer mestre:references
```
Adjust model attributes as needed based on the .detalhe(row) parsing logic.

### 4. Configure File Paths 🔧

In `config/application.rb`:
```ruby
module RcadApp
  class Application < Rails::Application
    config.load_defaults 8.0

    config.rcad_path = {
      original: Rails.root.join('rcad_files/original'),
      processados: Rails.root.join('rcad_files/processados'),
      erros: Rails.root.join('rcad_files/erros')
    }
  end
end
```
### 5. Create Directories

    mkdir -p rcad_files/{original,processados,erros}

You can now place .TXT files in rcad_files/original.
### 6. Create the RCAD Service 🧠

File: app/services/cargas/rcad_carga.rb

    📌 See full implementation above — includes collection setup, transaction handling, row dispatching, and directory movement.

### 7. Implement .detalhe(row) in Models 🧱

Example for Cliente:
```ruby
class Cliente < ApplicationRecord
  belongs_to :mestre

  def detalhe(row)
    linha = row.split('|')
    self.cnpj              = linha[2]
    self.cpf               = linha[3]
    self.dt_credenciamento = parse_data(linha[4])
  end

  private

  def parse_data(str)
    Date.strptime(str, '%Y%m%d') rescue nil
  end
end
```
Repeat for other models based on their layout in the RCAD spec.
### 8. Define Custom Inflection Rules

In config/initializers/inflections.rb:
```ruby
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'adquirencia', 'adquirencias'
  inflect.irregular 'uf_destinataria', 'uf_destinatarias'
  inflect.irregular 'autorizacao', 'autorizacoes'
end
```
This ensures proper pluralization when generating models or controllers.
### 9. Run Migrations 🔃

    rails db:create db:migrate

### 10. Add API Endpoint for File Upload 🧪
Generate controller:
```ruby
rails g controller api/v1/rcad --skip-template-engine --no-assets --api

Add action:

module Api
  module V1
    class RcadController < ApplicationController
      def processar
        result = Cargas::RcadCarga.new
        render json: { message: 'RCAD file processed successfully' }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end
```
Add route:

# config/routes.rb
```ruby
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'rcad/processar', to: 'rcad#processar'
    end
  end
end
```
### 11. Test It via Postman or Curl 💬

Start the server:

    rails s

Then run:

    curl -X POST http://localhost:3000/api/v1/rcad/processar

You should receive:

{"message":"RCAD file processed successfully"}

### 12. Manual Test via Console 🧪

    rails console
Then
    
    Cargas::RcadCarga.new

✅ Done!

You now have a production-ready Rails 8 app capable of parsing and storing fiscal data from RCAD-formatted files.
## Acknowledgements

 - [Jeovan Farias](https://www.linkedin.com/in/jeovan-f-6283b8145/)


## Authors

- [Jaythree](https://www.linkedin.com/in/giljrx/)


## License

[MIT](https://choosealicense.com/licenses/mit/)

