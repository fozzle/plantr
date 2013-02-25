class PlantsController < ApplicationController
  protect_from_forgery :except => [:show, :index, :create]
  before_filter :authenticate_user!

	def index
    @garden = Garden.find(params[:garden_id])
    if @garden.has_user(current_user)
  		@plants = @garden.plants.all

  		respond_to do |format|
        format.json { render json: @plants }
      end

    else
      render json: { error: "You are not part of this garden.", status: 403 }
    end

  end

  def show
    @garden = Garden.find(params[:garden_id])

    if @garden.has_user(current_user)
    	@plant = Plant.find(params[:id])

      if @garden.has_plant(@plant)
        respond_to do |format|
          format.json { render json: @plant }
        end
      else
        render json: { error: "Bad Request. Plant of id #{params[:id]} is not part of garden with id #{params[:garden_id]}.", status: 422}
      end

    else
      render json: { error: "You are not part of this garden.", status: 403 }
    end

  end

  def create
    @garden = Garden.find(params[:garden_id])

    if @garden.has_user(current_user)
      params[:plant] = params[:plant].merge(garden_id: params[:garden_id])
      @plant = Plant.new(params[:plant])

      respond_to do |format|
        if @plant.save
          format.json { render json: @plant, status: :created, location: garden_plants_url(@garden) }
        else
          format.json { render json: @plant.errors, status: :unprocessable_entity }
        end
      end

    else
      render json: { error: "You are not part of this garden.", status: 403}
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
end