class GroupsController < ApplicationController
  def index
  end

  def new
    @group = Group.new()
  end

  def create
    params[:kou_user] = current_user.id
    @group = Group.new(group_params)
    if @group.save
      redirect_to root_path
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @game = Game.find_by(group_id: params[:id])
    @kou = Kou.find_by(game_id: @game.id)
    @otu = Otu.find_by(game_id: @game.id)
    @group.destroy
    @kou.destroy
    @otu.destroy
    @game.destroy
    redirect_to root_path
  end

  private

  def group_params
    params.permit(:name, :otu_user, :kou_user)
  end

  def create_player
  end
end
