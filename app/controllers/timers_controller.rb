class TimersController < ApplicationController
  before_action :check_administrator, except: [:show, :start_timer]
  before_action :check_workie, only: :start_timer
  before_action :set_params, except: [:index, :create]

  def index
    timers = Timer.all
    render json: timers
  end

  def show
    render json: @timer
  end

  # def create
  #   timer= Timer.new(timer_params)
  #   if timer.save
  #     render json: {message: "Timer successfully created", Timer: timer}     
  #   else
  #     render json: {message: "something went wrong!!", errors: timer.errors.full_messages }
  #   end
  # end

  def update
    if @timer.update(timer_params)
      render json: {message: "Timer successfully updated", Timer: @timer}
    else
      render json: {message: "something went wrong!!", errors: @current_user.errors.full_messages }
    end
  end

  def destroy
    if @timer 
      @timer.destroy
      render json: "Task successfully deleted!!"      
    end
  end

  def start_timer
    task = Task.find(@timer.task_id)
    if task.status != "complete"
      t = @timer.time_in_minute 
      t.times do | i | 
        puts"Timer is running....#{i} second"
        sleep(1)
      end 
      task = task.update(status:"complete")
      if task
        render json: {message: "Task time is completed"}
        TimerMailer.with(timer: @timer).timer_complete.deliver_now 
      else
        render json: "something went wrong!!!"
      end
    else
      render json: "Task time is already ended"
    end
  end

  private
  def timer_params
    params.permit(:time_in_minute, :task_id, :user_id)
  end

  def set_params
      @timer = Timer.find(params[:id])
  end

end
