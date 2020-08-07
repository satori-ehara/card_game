class GamesController < ApplicationController
  before_action :get_game,only: [:index,:destroy,:update]
  before_action :get_kou_otu,only: [:destroy,:update]

  def index
    if @game
      @kou = Kou.find_by(game_id: @game.id)
      @otu = Otu.find_by(game_id: @game.id)
      get_gon
    end
  end

  def new
  end

  def create
    create_deck
    params[:condition] = "started"
    params[:field_card] = 0
    params[:turn] = "kou"
    params[:turn_count] = 0
    params[:action] = "kou"
    @kou_hand = []
    @otu_hand = []
    join_hand(@kou_hand)
    join_hand(@kou_hand)
    join_hand(@otu_hand)
    @games = Game.new(games_params)
    @games.deck << params[:deck][0] << params[:deck][1]
    if @games.save
      @kou = Kou.new()
      @otu = Otu.new()
      kou_create
      otu_create
      redirect_to group_games_path(params[:group_id])
    end
  end

  def destroy
    @kou.destroy
    @otu.destroy
    @game.destroy
    redirect_to group_games_path(params[:group_id])
  end

  def update
    @game.field_card = params[:number]
    check_turn_player(@game.turn).hand.delete_at(params[:hand].to_i)
    @game.turn = change_kou_otu(@game.turn)
    @game.action = change_kou_otu(@game.action)
    draw_hand(@game.turn)
    update_all
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

  def kou_create
    @kou.hand = @kou_hand
    @kou.user_id = Group.find_by(id: params[:group_id]).kou_user
    @kou.game_id = Game.find_by(group_id: params[:group_id]).id
    @kou.save
  end

  def otu_create
    @otu.hand = @otu_hand
    @otu.user_id = Group.find_by(id: params[:group_id]).otu_user
    @otu.game_id = Game.find_by(group_id: params[:group_id]).id
    @otu.save
  end

  def update_all
    @game.save
    @kou.save
    @otu.save
  end


  def join_hand(hand)
    hand << params[:deck][0][0]
    params[:deck][0] = params[:deck][0].drop(1)
  end

  def get_game
    @game = Game.find_by(group_id: params[:group_id])
  end

  def get_kou_otu
    @kou = Kou.find_by(game_id: params[:id])
    @otu = Otu.find_by(game_id: params[:id])
  end

  def get_gon
    gon.game_id = @game.id
    gon.group_id = @game.group_id
    gon.user_id = current_user.id
    gon.action_id = check_id(@game.action)
  end

  def change_kou_otu(turn)
    if turn == "otu"
      turn = "kou"
    elsif turn == "kou"
      turn = "otu"
    end
  end

  def check_id(action)
    if action == "kou"
      return @kou.user_id
    elsif action == "otu"
      return @otu.user_id
    end
  end

  def check_turn_player(action)
    if action == "kou"
      return @kou
    elsif action == "otu"
      return @otu
    end
  end

  def draw_hand(action)
    check_turn_player(action).hand << @game.deck[0][0]
    @game.deck[0] = @game.deck[0].drop(1)
  end

end
