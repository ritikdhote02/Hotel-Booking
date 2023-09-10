class Timer < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :time_in_minute, presence: true
end
