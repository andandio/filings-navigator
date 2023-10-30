class Api::FilersController < ApplicationController
  include Serializable

  def index
    filers = Filer.all
    render json: {
      success: true,
      message: '',
      data: serialize(filers, filing_years: false)
    }
  end

  def show
    filer = Filer.find(params[:id])
    render json: {
      success: true,
      message: '',
      data: serialize(filer, filing_years: true)
    }
  end
end