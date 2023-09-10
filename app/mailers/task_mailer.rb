class TaskMailer < ApplicationMailer
  def task_assigned
    task = params[:task]
    @user= User.find(task.assign_to)
    mail(to: @user.email, subject: "New task!")
  end

  # def task_complete
  #   @user= User.find(1)
  #   mail(to: @user.email, subject: "Task status updated!!!")
  # end
end
