class TasksController < ApplicationController
  before_action :set_params, except: [:index, :create]
  before_action :check_administrator, except: [:index, :show]

  def index
    if @current_user.type == "Administrator"
      tasks = @current_user.tasks
      render json: tasks
    else
      assign_tasks = Task.where(assign_to:@current_user.id)
      render json: assign_tasks
    end
  end

  def show
    render json: @task
  end

  def create
    task = @current_user.tasks.new(task_params)
    if task.save
      render json: "Task successfully created"  
      TaskMailer.with(task: task).task_assigned.deliver_now   
    else
      render json: {message: "something went wrong!!", errors: @current_user.errors.full_messages }
    end
  end

  def update
    if @task.update(task_params)
      render json: "Task successfully updated"      
    else
      render json: {message: "something went wrong!!", errors: @current_user.errors.full_messages }
    end
  end

  def destroy
    if @task 
      @task.destroy
      render json: "Task successfully deleted!!"      
    end
  end
  

  private
  def task_params
    params.require(:task).permit(:title, :description, :assign_to, :status, timer_attributes: [:time_in_minute, :user_id])
  end

  def set_params
    if @current_user.type == "Administrator"
      @task = @current_user.tasks.find(params[:id])
    else
      assign_task = Task.where(assign_to:@current_user.id)
      @task = assign_task.find(params[:id])
    end
  end
end
