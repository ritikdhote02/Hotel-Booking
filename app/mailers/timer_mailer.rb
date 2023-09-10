class TimerMailer < ApplicationMailer
    def timer_complete
        # timer = params[:timer].task.assign_to
        # data = Task.find(timer.task_id)
        @user= User.find(params[:timer]&.task&.assign_to)
        mail(to: @user.email, subject: "Task status updated!!!")
      end
end
