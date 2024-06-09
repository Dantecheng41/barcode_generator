# frozen_string_literal: true

Rails.application.routes.draw do
  root 'barcodes#index'

  get 'barcode', to: 'barcodes#new'
  get 'convert_barcode', to: 'barcodes#convert_barcode'

  get 'ocr_barcode', to: 'ocr#new'
  post 'convert_to_barcode', to: 'ocr#convert_to_barcode'

  get 'ocr_barcodes', to: 'ocr#multi_new'
  post 'convert_to_barcodes', to: 'ocr#convert_to_barcodes'
end
