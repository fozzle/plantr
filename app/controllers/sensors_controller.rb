class SensorsController < ApplicationController
  # GET /sensors
  # GET /sensors.json
  # def index
  #   @sensors = Sensor.all

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @sensors }
  #   end
  # end

  # GET /sensors/1
  # GET /sensors/1.json
  def show
    @sensor = Sensor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sensor }
    end
  end

  # POST /sensors
  # POST /sensors.json
  def create
    @sensor = Sensor.new(params[:sensor])

    respond_to do |format|
      if @sensor.save
        format.json { render json: @sensor, status: :created, location: @sensor }
      else
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end
end
