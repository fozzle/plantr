class LogsController < ApplicationController

  def index
    @logs = Log.all

    respond_to do |format|
      format.html
      format.json { render json: @logs }
    end
  end

  def create
    @log = Log.new(params[:log])
    respond_to do |format|
      if @log.save
        format.html { redirect_to @log, notice: 'log created.' }
        format.json { render json: @log, status: :created, location: @log }
      else
        format.html { render action: "new" }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end


end