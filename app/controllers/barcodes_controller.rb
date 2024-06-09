# frozen_string_literal: true

class BarcodesController < ApplicationController
  def convert_barcode
    return unless params[:mail_number]

    @src = BarcodeService.new(params[:mail_number]).src
  end
end
