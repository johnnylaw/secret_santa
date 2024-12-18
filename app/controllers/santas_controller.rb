class SantasController < ApplicationController
  def show
    @santa = Santa.find_by(permalink: params[:permalink])
  end
end
