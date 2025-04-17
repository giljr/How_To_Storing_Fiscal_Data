# app/controllers/api/v1/rcad_controller.rb
Rails.logger.info "🔄 RCAD Processing started via API"
module Api
  module V1
    class RcadController < ApplicationController
      def processar
        begin
          Cargas::RcadCarga.new # This already triggers `start` in initialize
          render json: { message: 'RCAD file processed successfully' }, status: :ok
        rescue => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end
    end
  end
end
