class CreateTimers < ActiveRecord::Migration[7.0]
  def change
    create_table :timers do |t|
      t.integer :time_in_minute
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
