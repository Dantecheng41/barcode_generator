# frozen_string_literal: true

require 'rtesseract'
require 'rmagick'

class OcrService
  attr_reader :image_path

  def initialize(image_path)
    @image_path = image_path
  end

  def rows
    text = RTesseract.new(parse_img_path(image_path, 0.65, 0.95), lang: 'chi_tra').to_s
    result = []

    text_rows = text.split("\n").select(&:present?)

    text_rows.each_slice(2) do |adm, number|
      adm = adm.gsub('懸', '縣')

      post_number = number.scan(/\d{6}\s\d{6}\s\d{2}\s\d{5}\s\d{1}/)[0].split.join

      row = {
        adm: adm.gsub(/\s/, '').scan(/(?:\p{Han}{2}(?:縣|市)\p{Han}{1,3}(?:區|鄉|鎮|市))/)[0],
        post_number: parse_post_number(post_number),
        barcode_src: BarcodeService.new(post_number).src
      }

      Rails.logger.info "row: #{row}"
      result << row
    rescue StandardError => e
      Rails.logger.info "adm: #{adm}, number:#{number}, error: #{e.message}"
      result << {
        adm: nil,
        post_number: parse_post_number(post_number),
        barcode_src: number
      }
    end

    result
  end

  def row
    text = RTesseract.new(parse_img_path(image_path, 0.65, 0.95), lang: 'chi_tra').to_s
    post_number = text.scan(/\b\d{6}\s\d{6}\s\d{2}\s\d{5}\s\d{1}\b/)[0].split.join

    {
      adm: text.gsub(/\s/, '').scan(/(?:\p{Han}{2}(?:縣|市)\p{Han}{1,3}(?:區|鄉|鎮|市))/)[0],
      post_number: parse_post_number(post_number),
      barcode_src: BarcodeService.new(post_number).src
    }
  rescue StandardError
    {
      adm: nil,
      post_number: parse_post_number(post_number),
      barcode_src: post_number
    }
  end

  private

  def parse_img_path(image_path, _lv = 0.65, _th = 0.9)
    processed_image_path = "#{Rails.root}/tmp/processed_image.png"

    img = Magick::Image.read(image_path).first
    # img = img.level(0, Magick::QuantumRange * lv)
    # img = img.quantize(256, Magick::GRAYColorspace)

    # img = img.threshold(Magick::QuantumRange * th)
    # img = img.median_filter(3)

    img.write(processed_image_path)

    processed_image_path
  end

  def parse_post_number(value)
    str_idx = 0

    result = [6, 6, 2, 5, 1].map do |i|
      cur_idx = str_idx
      str_idx += i
      value[cur_idx, i]
    end.join('-')

    result.size == 24 ? result : nil
  rescue StandardError
    nil
  end
end
