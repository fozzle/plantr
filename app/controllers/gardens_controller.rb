class GardensController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  layout 'home'
  
  def index
    @gardens = current_user.gardens
  end

  def new
  end

  def edit
    render :layout => 'garden'
  end

  def create
    @garden = Garden.new(params[:garden])

    if @garden.save
      @garden.users << current_user
      redirect_to gardens_path
    else
      render :action => 'new'
    end
  end

  def update
    @garden = Garden.find(params[:id])

    if @garden.has_user(current_user)
      if params[:garden].include? :user_ids
        params[:garden][:user_ids].each do |user_id|
          next if user_id.empty?
          user = User.find(user_id)
          @garden.users.delete(user)
        end
        
        flash[:success] = "Saved!"
        redirect_to garden_users_path(@garden)
      elsif @garden.update_attributes(params[:garden])
        flash[:success] = "Saved!"
        redirect_to garden_plants_path(@garden)
      else
        render :action => 'edit'
      end
    else
      flash[:error] = "You are not a part of this garden."
      redirect_to gardens_path
    end
  end

  def destroy
    @garden = Garden.find(params[:id])

    if @garden.has_user(current_user)
      @garden.destroy

      redirect_to gardens_path
    else
      flash[:error] = "You are not a part of this garden."
      redirect_to gardens_path
    end
  end

  def weather
    @garden = Garden.find(params[:id])
    require 'barometer'

    barometer = Barometer.new(@garden.zip_code)
    @weather = barometer.measure
    
    render :layout => 'garden' 
  end

  def add_member
    @garden = Garden.find(params[:id])

    if @garden.has_user(current_user)
      @user = User.find(params[:user_id])
      if not @user.blank?
        if not @garden.users.include?(@user)
          @garden.users << User.find(params[:user_id])
          @garden.save

          respond_to do |format|
            format.json { render json: @garden.users.all }
          end

        else
          render json: { errors: "User has already been added.", status: 400}
        end
      end
      
    else
      render json: { errors: "You are not part of this garden.", status: 403 }
    end
  end

  def members
    @garden = Garden.find(params[:id])
    respond_to do |format|
      format.json { render json: @garden.users.all }
    end
  end

  def remove_member
    @garden = Garden.find(params[:id])
    @user = User.find(params[:user_id])
    if @garden.has_user(current_user) and @user == current_user
      @garden.users.delete(@user)
      render json: @garden.users.all
    else
      render json: { errors: "You are not allowed to take this action.", status: 400 }
    end
  end
end
