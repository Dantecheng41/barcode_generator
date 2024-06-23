class TextController < ApplicationController
  def parse_to_barcodes
    return unless params[:text].present?

    @rows = TextParseService.new(params[:text]).rows

    render action: :create_success
  end
end