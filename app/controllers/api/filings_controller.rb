class Api::FilingsController < ApplicationController 
  include Serializable

  def index
    filing_id = filtered_params[:resource_id] 
    filing = Filing.find(filing_id) if filing_id
    filings = Filing.where(filer_id: filing.filer_id) if filing
    filings = Filing.all if !filings
    render json: {
      success: true,
      message: '',
      data: serialize(filings, {include_filing_years: false})
    }
  end

  def filtered_params
    params.permit(:resource_id)
  end
end