class V1::HomeController < ApplicationController


  

  def index
    render json: { data: HomeSerializer.new(Meeting.first).as_json, klass: 'Home' }, status: :ok
  end

  def import
    ImportJob.perform_later(3991)

  end



end
