class PlantsController < ApplicationController
  before_filter :authenticate_user!
  layout 'garden'

  def index
    @garden = Garden.find(params[:garden_id])
    @plants = @garden.plants.all

    authorize! :manage, @garden
  end

  def show
    @plant = Plant.find(params[:id])

    # TODO: What's the deal with .last? Investigate it's broken-ness
    @logs = @plant.logs.limit(150).order('id DESC')
    authorize! :read, @plant

    @moisture_points = @logs.map { |x| [x.created_at.to_time.to_i*1000, x.moisture/10] }
    @sunlight_points = @logs.map { |x| [x.created_at.to_time.to_i*1000, x.sunlight/10] }

    render :layout => 'plants'
  end

  def new
    @garden = Garden.find(params[:garden_id])

    authorize! :manage, @garden
    @plant = @garden.plants.build
  end

  def create
    @garden = Garden.find(params[:garden_id])
    authorize! :manage, @garden

    @plant = @garden.plants.build(params[:plant])

    if @plant.save
      flash[:success] = "You've added your plant! The sensor will start logging its health."
      redirect_to garden_plants_path(@garden)
    else
      render :action => 'new'
    end
  end

  def edit
    @plant = Plant.find(params[:id])
    authorize! :edit, @plant

    render :layout => 'plants'
  end

  def update
    @plant = Plant.find(params[:id])
    authorize! :manage, @plant

    if params[:plant].include? :task_ids
      params[:plant][:task_ids].each do |task_id|
        Task.find(task_id).destroy unless task_id.empty?
      end

      flash[:success] = "Saved!"
      redirect_to plant_tasks_path(@plant)
    elsif @plant.update_attributes(params[:plant])
      if @plant.clear_logs == '1'
        @plant.logs.delete_all
      end

      flash[:success] = "Saved!"
      redirect_to plant_path(@plant)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @plant = Plant.find(params[:id])
    @garden = @plant.garden

    authorize! :destroy, @plant
    @plant.destroy

    redirect_to garden_plants_path(@garden)
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