class UsersController < ApplicationController
  layout 'garden'
  before_filter :authenticate_user!
  
  def index
    @garden = Garden.find(params[:garden_id])

    if @garden.has_user(current_user)
      @users = @garden.users
    else
      flash[:error] = "You are not a part of this garden."
    end
  end

  def new
    @garden = Garden.new
  end

  def edit
    @garden = Garden.find(params[:id])
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
      if @garden.update_attributes(params[:garden])
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