class TasksController < ApplicationController
  include IceCube
  before_filter :authenticate_user!
  layout 'plants'

  def index
    @plant = Plant.find(params[:plant_id])
    @tasks = @plant.tasks.all

    authorize! :manage, @plant
  end

  def new
    @plant = Plant.find(params[:plant_id])

    authorize! :manage, @plant
    @task = @plant.tasks.build
  end

  def create
    @plant = Plant.find(params[:plant_id])
    authorize! :manage, @plant

    params[:task][:weeks] ||= 1
    params[:task][:weeks] = params[:task][:weeks].to_i
    params[:task][:days].map! { |x| x.to_i }

    schedule = Schedule.new
    schedule.add_recurrence_rule Rule.weekly(params[:task][:weeks]).day(*params[:task][:days])

    @task = @plant.tasks.build(params[:task])
    @task.schedule = schedule

    if @task.save
      flash[:success] = "Saved!"
      redirect_to plant_tasks_path(@plant)
    else
      render :action => 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
    authorize! :edit, @task

    render :layout => 'plants'
  end

  def update
    @task = Task.find(params[:id])
    authorize! :edit, @task

    if @plant.update_attributes(params[:plant])
      flash[:success] = "Saved!"
      redirect_to plant_tasks_path(@plant)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @plant = @task.plant

    authorize! :destroy, @task
    @task.destroy

    redirect_to garden_plants_path(@plant)
  end
end