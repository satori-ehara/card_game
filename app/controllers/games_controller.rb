class GamesController < ApplicationController
  def index
  end

  def new
  end

  def create
    create_deck

    binding.pry
  end

  private
  def create_deck
    params[:deck] = [1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,10].shuffle
    last_card = params[:deck].pop
    params[:deck] = [params[:deck],[last_card]]
  end
end
