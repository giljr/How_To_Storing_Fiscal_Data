require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module RcadApp
  class Application < Rails::Application
    config.load_defaults 8.0

    config.rcad_path = {
      original:    Rails.root.join("rcad_files/original"),
      processados: Rails.root.join("rcad_files/processados"),
      erros:       Rails.root.join("rcad_files/erros")
    }
  end
end
