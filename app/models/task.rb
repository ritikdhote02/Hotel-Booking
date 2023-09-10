class Task < ApplicationRecord
  belongs_to :user
  has_one :timer, dependent: :destroy
  accepts_nested_attributes_for :timer

  validates :title, :assign_to,  presence: true
  validates :status ,presence:true, inclusion: { in: %w(working complete) } 
  validate :administrator_only_create_task

  def administrator_only_create_task
    unless user.type == "Administrator"
      errors.add(:base, "Only Administrator have permission to create tasks.")  
    end
  end
end
