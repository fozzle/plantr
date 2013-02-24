class PlantsController < ApplicationController

	def index
		@plants = Plant.all

		respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plants }
    end

  end

  def show
  	@plant = Plant.find(params[:id])

  	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plant }
    end

  end

  def create
    @plant = Plant.new(params[:plant])
    respond_to do |format|
      if @plant.save
        format.html { redirect_to @plant, notice: 'Plant created.' }
        format.json { render json: @plant, status: :created, location: @plant }
      else
        format.html { render action: "new" }
        format.json { render json: @plant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @plant = Plant.find(params[:id])

    respond_to do |format|
      if @plant.update_attributes(params[:plant])
        format.html { redirect_to @plant, notice: 'Plant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plants/1
  # DELETE /plants/1.json
  def destroy
    @plant = Plant.find(params[:id])
    @plant.destroy

    respond_to do |format|
      format.html { redirect_to plants_url }
      format.json { head :no_content }
    end
  end
end