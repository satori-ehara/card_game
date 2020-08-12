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
    @games.message = "ゲームが開始されました。"
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
    if @game.deck[0].length == 0
      @game.field_card = params[:number]
      @game.action = "fight"
      check_turn_player(@game.turn).hand.delete_at(params[:hand].to_i)
      if @kou.hand[0] < @otu.hand[0]
        @game.condition = "otu"
      elsif @kou.hand[0] > @otu.hand[0]
        @game.condition = "kou"
      else
        @game.condition = "draw"
      end
      update_all
    else
      if params[:number].to_i == 0
        render json:{number: 0}
        turn_change_action
      else
        check_card_number(params[:number].to_i)
      end
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

  def turn_change_action
    @game.turn = change_kou_otu(@game.turn)
    @game.action = change_kou_otu(@game.action)
    if check_turn_player(@game.turn).condition == "guard"
      check_turn_player(@game.turn).condition = ""
      draw_hand(@game.turn)
      update_all
    elsif check_turn_player(@game.turn).condition == "wise"
      change_message("未来視を発動中です...")
      array = [@game.deck[0][0],@game.deck[0][1],@game.deck[0][2]]
      check_turn_player(@game.turn).hand[1] = array
      @game.deck[0] = @game.deck[0].drop(3)
      update_all
    else
    draw_hand(@game.turn)
    update_all
    end
  end

  def put_card_action
    @game.field_card = params[:number]
    check_turn_player(@game.turn).discard << params[:number]
    check_turn_player(@game.turn).hand.delete_at(params[:hand].to_i)
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
    gon.game = @game

    gon.kou = @kou
    gon.otu = @otu
  end

  def change_kou_otu(turn)
    if turn == "otu"
      turn = "kou"
    elsif turn == "kou"
      turn = "otu"
    end
  end

  def change_message(message)
    @game.message = message
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
    check_turn_player(action).hand = check_turn_player(action).hand.shuffle
    @game.deck[0] = @game.deck[0].drop(1)
  end

  def check_card_number(number)
    case number
    when 1 then
      card_one
    when 2 then
      card_two
    when 21 then
      card_two_one
    when 3 then
      card_three
    when 4 then
      card_four
    when 5 then
      card_five
    when 6 then
      card_six
    when 7 then
      card_seven
    when 71 then
      card_seven_one
    when 8 then
      card_eight
    when 9 then
      card_nine
    when 91 then
      card_nine_one
    else
    end
  end

  def card_one
    if @game.deck[1] == 1 || @game.deck[0].include?(1) || check_turn_player(change_kou_otu(@game.turn)).condition == "guard"
      put_card_action
      render json:{number: @game.field_card.to_i}
      change_message("最初の1なので、効果はありませんでした。")
      turn_change_action
    else
      put_card_action
      draw_hand(change_kou_otu(@game.turn))
      update_all
      render json:{number: 9,card: check_turn_player(change_kou_otu(@game.turn)).hand}
      ##9と処理が同じなので９と同じ非同期通信へ
    end
  end

  def card_two
    put_card_action
    update_all
    render json:{number: params[:number].to_i}
  end
  def card_two_one
    if check_turn_player(change_kou_otu(@game.turn)).hand[0] == params[:hand].to_i
      if params[:hand].to_i != 10
        @game.condition = @game.turn
        change_message(params[:hand] + "を指摘し、成功しました。")
        update_all
      else
        check_turn_player(change_kou_otu(@game.turn)).hand[0] == @game.deck[1]
        check_turn_player(change_kou_otu(@game.turn)).discard << 10
        change_message(params[:hand] + "を指摘し、成功しましたが10であるため転生しました。")
        update_all
        turn_change_action
      end
    else
      change_message(params[:hand] + "を指摘しましたが、失敗に終わりました。")
      turn_change_action
    end
    render json:{number: params[:number].to_i}
  end

  def card_three
    if check_turn_player(change_kou_otu(@game.turn)).condition != "guard"
      put_card_action
      change_message("透視が発動しました。")
      update_all
      render json:{number: 3,card: check_turn_player(change_kou_otu(@game.turn)).hand[0]}
    else
      put_card_action
      change_message("守護があるため、能力は発動しませんでした。")
      render json:{number: 0}
      turn_change_action
    end
  end
  def card_four
    check_turn_player(@game.turn).condition = "guard"
    put_card_action
    change_message("守護が発動しました。")
    render json:{number: @game.field_card.to_i}
    turn_change_action
  end
  def card_five
    if check_turn_player(change_kou_otu(@game.turn)).condition != "guard"
      put_card_action
      draw_hand(change_kou_otu(@game.turn))
      update_all
      render json:{number: @game.field_card.to_i,card: check_turn_player(change_kou_otu(@game.turn)).hand}
    else
      put_card_action
      change_message("守護があるため、能力は発動しませんでした。")
      render json:{number: 0}
      turn_change_action
    end
  end

  def card_six
    if check_turn_player(change_kou_otu(@game.turn)).condition != "guard"
      put_card_action
      change_message("決闘が発動しました。")
      if @kou.hand[0] < @otu.hand[0]
        @game.action = "fight"
        @game.condition = "otu"
      elsif @kou.hand[0] > @otu.hand[0]
        @game.action = "fight"
        @game.condition = "kou"
      else
        change_message("引き分け（続行）となりました。")
        turn_change_action
      end
      render json:{number: @game.field_card.to_i}
      update_all
    else
      change_message("守護があるため、決闘は発動しませんでした。")
      put_card_action
      render json:{number: 0}
      turn_change_action
    end
  end

  def card_seven
    check_turn_player(@game.turn).condition = "wise"
    put_card_action
    change_message("未来視が発動しました。")
    render json:{number: @game.field_card.to_i}
    turn_change_action
  end
  def card_seven_one
    hand = check_turn_player(@game.turn).hand[1][params[:hand].to_i]
    check_turn_player(@game.turn).hand[1].delete_at(params[:hand].to_i)
    @game.deck[0] << check_turn_player(@game.turn).hand[1][0]
    @game.deck[0] << check_turn_player(@game.turn).hand[1][1]
    @game.deck[0] = @game.deck[0].shuffle
    check_turn_player(@game.turn).hand.delete_at(1)
    check_turn_player(@game.turn).hand << hand
    check_turn_player(@game.turn).condition = ""
    change_message("未来視によってカードが選ばれました。")
    update_all

    render json:{number: 0}
  end

  def card_eight
    if check_turn_player(change_kou_otu(@game.turn)).condition != "guard"
      change_message("交換が発動しました。")
      put_card_action
      card = @kou.hand[0]
      @kou.hand[0] = @otu.hand[0]
      @otu.hand[0] = card
      render json:{number: @game.field_card.to_i}
      turn_change_action
    else
      change_message("守護があるため、交換が発動しませんでした。")
      put_card_action
      render json:{number: 0}
      turn_change_action
    end
  end
  def card_nine
    if check_turn_player(change_kou_otu(@game.turn)).condition != "guard"
      put_card_action
      draw_hand(change_kou_otu(@game.turn))
      update_all
      render json:{number: @game.field_card.to_i,card: check_turn_player(change_kou_otu(@game.turn)).hand}
    else
      change_message("守護があるため、公開処刑が発動しませんでした。")
      put_card_action
      render json:{number: 0}
      turn_change_action
    end
  end
  def card_nine_one
    if @game.field_card == 9
      change_message("公開処刑により" + check_turn_player(change_kou_otu(@game.turn)).hand[params[:hand].to_i].to_s + "が捨てられました。")
    elsif @game.field_card == 1
      change_message("革命により" + check_turn_player(change_kou_otu(@game.turn)).hand[params[:hand].to_i].to_s + "が捨てられました。")
    elsif @game.field_card == 5
      change_message("疫病により" + check_turn_player(change_kou_otu(@game.turn)).hand[params[:hand].to_i].to_s + "が捨てられました。")
    end
    if check_turn_player(change_kou_otu(@game.turn)).hand[params[:hand].to_i] == 10
      if @game.field_card == 9
        change_message("公開処刑により英雄が処刑されたため、試合は終了となります。")
        @game.condition = @game.turn
        update_all
      else
        change_message("英雄が捨てられたため、転生しました。")
        check_turn_player(change_kou_otu(@game.turn)).discard << check_turn_player(change_kou_otu(@game.turn)).hand[params[:hand].to_i]
        check_turn_player(change_kou_otu(@game.turn)).hand.delete_at(params[:hand].to_i)
        check_turn_player(change_kou_otu(@game.turn)).discard << check_turn_player(change_kou_otu(@game.turn)).hand[0]
        check_turn_player(change_kou_otu(@game.turn)).hand.delete_at(0)
        check_turn_player(change_kou_otu(@game.turn)).hand << @game.deck[1][0]
        binding.pry
        turn_change_action
      end
    else
      check_turn_player(change_kou_otu(@game.turn)).discard << check_turn_player(change_kou_otu(@game.turn)).hand[params[:hand].to_i]
      check_turn_player(change_kou_otu(@game.turn)).hand.delete_at(params[:hand].to_i)
      check_turn_player(change_kou_otu(@game.turn)).hand[0] == @game.deck[1] ##転生
      turn_change_action
    end
    render json:{number: 0}
  end

end
