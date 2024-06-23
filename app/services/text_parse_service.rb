class TextParseService
  def initialize(text)
    @text = text
  end

  def rows
    result = []

    @text.split("\r\n\r\n").each_slice(4) do |district, type, post_number, weight|
      result << {
        adm: district,
        weight: weight,
        post_number: parse_post_number(post_number),
        barcode_src: BarcodeService.new(post_number).src
      }
    end

    result
  end

  private

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