class PlantsController < ApplicationController
  load_and_authorize_resource :garden
  layout 'garden'
  before_filter :authenticate_user!

	def index
    @garden = Garden.find(params[:garden_id])
  	@plants = @garden.plants.all
  end

  def show
    @garden = Garden.find(params[:garden_id])

    if @garden.has_user(current_user)
    	@plant = Plant.find(params[:id])

      unless @garden.has_plant(@plant)
        flash[:error] = "That plant doesn't belong in that garden."
        redirect_to garden_plants_path
      end
    else
      flash[:error] = "You are not part of this garden."
      redirect_to gardens_path
    end
  end

  def new
    @garden = Garden.find(params[:garden_id])
    @plant = @garden.plants.build
  end

  def create
    @garden = Garden.find(params[:garden_id])

    if @garden.has_user(current_user)
      params[:plant] = params[:plant].merge(garden_id: params[:garden_id])
      @plant = Plant.new(params[:plant])

      if @plant.save
        flash[:success] = "You've added your plant! The sensor will start logging its health."
        redirect_to garden_plants_path(@garden)
      else
        render :action => 'new'
      end
    else
      flash[:error] = "You are not a part of this garden."
      redirect_to gardens_path
    end
  end

  def update
    @garden = Garden.find(params[:garden_id])

    if @garden.has_user(current_user)
      @plant = Plant.find(params[:id])

      respond_to do |format|
        if @plant.update_attributes(params[:plant])
          format.json { head :no_content }
        else
          format.json { render json: @plant.errors, status: :unprocessable_entity }
        end
      end

    else
      render json: { error: "You are not part of this garden.", status: 403 }
    end
  end

  # DELETE /plants/1
  # DELETE /plants/1.json
  def destroy
    @garden = Garden.find(params[:garden_id])

    if @garden.has_user(current_user)

      @plant = Plant.find(params[:id])
      @plant.destroy

      respond_to do |format|
        format.json { head :no_content }
      end

    else
      render json: { error: "You are not part of this garden.", status: 403 }
    end
  end

  def logs
    @garden = Garden.find(params[:garden_id])

    if @garden.has_user(current_user)
      @plant = Plant.find(params[:id])
      unless @plant.sensor.blank?
        render json: @plant.sensor.logs.all
      else
        render json: { error: "No sensor assigned for this plant.", status: 400 }
      end
    else
      render json: { error: "You are not part of this garden.", status: 403 }
    end
  end
end