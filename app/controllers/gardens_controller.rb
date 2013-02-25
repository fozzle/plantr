class GardensController < ApplicationController
  skip_before_filter :verify_authenticity_token

  before_filter :authenticate_user!
  # GET /gardens
  # GET /gardens.json
  def index
    @gardens = current_user.gardens.all

    respond_to do |format|
      format.json { render json: @gardens.to_json(include: :plants) }
    end
  end

  # GET /gardens/1
  # GET /gardens/1.json
  def show
    @garden = Garden.find(params[:id])

    if @garden.has_user(current_user)
      respond_to do |format|
        format.json { render json: @garden }
      end
    else
      render json: { errors: "You are not part of this garden.", status: 403 }
    end

  end

  # GET /gardens/new
  # GET /gardens/new.json
  def new
    @garden = Garden.new

    respond_to do |format|
      format.json { render json: @garden }
    end
  end

  # GET /gardens/1/edit
  def edit
    @garden = Garden.find(params[:id])
  end

  # POST /gardens
  # POST /gardens.json
  def create
    @garden = Garden.new(params[:garden])
    @garden.users << current_user
    respond_to do |format|
      if @garden.save
        format.json { render json: @garden, status: :created, location: @garden }
      else
        format.json { render json: @garden.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gardens/1
  # PUT /gardens/1.json
  def update
    @garden = Garden.find(params[:id])

    if @garden.has_user(current_user)

      respond_to do |format|
        if @garden.update_attributes(params[:garden])
          format.json { head :no_content }
        else
          format.json { render json: @garden.errors, status: :unprocessable_entity }
        end
      end

    else
      render json: { errors: "You are not part of this garden.", status: 403 }
    end
  end

  # DELETE /gardens/1
  # DELETE /gardens/1.json
  def destroy
    @garden = Garden.find(params[:id])

    if @garden.has_user(current_user)

      @garden.destroy

      respond_to do |format|
        format.json { head :no_content }
      end

    else
      render json: { errors: "You are not part of this garden.", status: 403 }
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
