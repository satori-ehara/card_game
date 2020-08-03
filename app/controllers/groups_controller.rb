class GroupsController < ApplicationController
  def index
  end

  def new
    @group = Group.new()
  end

  def create
  end

  private

  def group_params
    params.permit(:name)
  end
end
