class GamesController < ApplicationController
  def index
    @game = Game.find_by(group_id: params[:group_id])
    binding.pry
  end

  def new
  end

  def create
    create_deck
    params[:condition] = "started"
    params[:field_card] = 0
    params[:turn] = "kou"
    params[:turn_count] = 0
    params[:action] = "create"
    @games = Game.new(games_params)
    @games.deck << params[:deck][0] << params[:deck][1]
    if @games.save
      redirect_to group_games_path(params[:group_id])
    end
  end

  private
  def create_deck
    params[:deck] = [1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,10].shuffle
    last_card = params[:deck].pop
    params[:deck] = [params[:deck],[last_card]]
  end

  def games_params
    params.permit(:condition,:deck,:field_card,:turn,:turn_count,:action,:group_id)
  end
end
