class Api::GamesController < ApplicationController
  def index
    @game = Game.find_by(group_id: params[:group_id])
    if params[:count].to_i < @game.turn_count
      render json:{reload: "true"}
    else
      render json:{reload: "false"}
    end
  end
end