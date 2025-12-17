class SantasController < ApplicationController
  def show
    @santa = Santa.find_by(permalink: params[:permalink])
  end

  def update
    @santa = Santa.find_by(permalink: params[:permalink])
    if @santa.update(preferences: params[:santa][:preferences])
      redirect_to action: :show, permalink: @santa.permalink, notice: 'Preferences updated successfully.'
    else
      render :show
    end
  end
end
