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

  private

  def group_params
    params.permit(:name, :otu_user, :kou_user)
  end

  def create_player
  end
end
