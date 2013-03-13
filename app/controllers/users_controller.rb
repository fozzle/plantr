class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'garden'
  
  def index
    @garden = Garden.find(params[:garden_id])
    authorize! :manage, @garden

    @users = @garden.users.without_user(current_user)
  end

  def new
    @garden = Garden.find(params[:garden_id])
    authorize! :manage, @garden

    @user = User.new
  end

  def create
    @garden = Garden.find(params[:garden_id])
    authorize! :manage, @garden

    @user = User.find_by_username(params[:user][:username])

    if @garden.users.include? @user
      @user = User.new
      flash[:error] = 'That user is already part of this garden.'
      render :action => 'new'
    elsif not @user.nil?
      @garden.users << @user

      flash[:success] = "Saved!"
      redirect_to garden_users_path(@garden)
    else
      @user = User.new
      flash[:error] = 'User not found.'
      render :action => 'new'
    end
  end

  def destroy
    @garden = Garden.find(params[:garden_id])
    @user = User.find(params[:id])

    authorize! :manage, @garden

    @garden.users.delete(@user)
    redirect_to garden_users_path(@garden)
  end
end
