# frozen_string_literal: true

require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

class BarcodeService
  attr_reader :number

  def initialize(number)
    @number = number
  end

  def src
    barcode = Barby::Code128B.new(number)
    outputter = Barby::PngOutputter.new(barcode)

    barcode_base64 = Base64.encode64(outputter.to_png)
    "data:image/png;base64,#{barcode_base64}"
  end
end
