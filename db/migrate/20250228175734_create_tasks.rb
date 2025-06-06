class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :status, default: 0
      t.integer :experience_reward
      t.datetime :completed_at

      t.timestamps
    end
  end
end
