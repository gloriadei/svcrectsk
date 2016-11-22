class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.datetime :starttime
      t.integer :duration
      t.string :jobid
      t.datetime :postedforpickup

      t.timestamps
    end
  end
end
