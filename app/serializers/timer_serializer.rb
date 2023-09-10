class TimerSerializer < ActiveModel::Serializer
  attributes :id, :time_in_minute, :task_title, :task_status
  def task_title
    object.task.title
  end
  def task_status
    object.task.status
  end
end
