# frozen_string_literal: true

class OcrController < ApplicationController
  def convert_to_barcodes
    return unless params[:image].present?

    @rows = OcrService.new(params[:image].path).rows

    render action: :create_success
  end

  def convert_to_barcode
    return unless params[:image].present?

    @rows = [OcrService.new(params[:image].path).row]

    render action: :create_success
  end
end
