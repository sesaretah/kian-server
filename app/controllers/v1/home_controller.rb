class V1::HomeController < ApplicationController


  

  def index
    render json: { data: HomeSerializer.new(Meeting.first).as_json, klass: 'Home' }, status: :ok
  end



end
