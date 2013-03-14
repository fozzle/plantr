class LogsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  # def index
  #   @logs = Log.all

  #   respond_to do |format|
  #     format.html
  #     format.json { render json: @logs }
  #   end
  # end

  def create
    sensor = Sensor.find(params[:sensor_id])
    log = sensor.logs.build(params[:log])
    respond_to do |format|
      if log.save
        format.json { render json: log, status: :created }
      else
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end


end