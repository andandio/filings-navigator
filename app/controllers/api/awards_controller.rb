class Api::AwardsController < ApplicationController
  include Serializable

  def index
    if filtered_params[:year] && filtered_params[:filer_id]
      filing = Filing.by_filer_for_year(
        filtered_params[:filer_id],
        filtered_params[:year]
      ).first
      awards = filing.awards if filing
    else
      awards = Award.all
    end
    render json: {
      success: true,
      message: '',
      data: serialize(awards, {})
    }
  end

  private

  def filtered_params
    params.permit(
      :year,
      :filer_id
    )
  end
end