class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :assign_to, :status
  has_one :timer
end
