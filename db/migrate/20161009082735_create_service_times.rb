class CreateServiceTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :service_times do |t|
      t.datetime :service_start_time
      t.integer :duration_of_recording
      t.integer :minutes_of_prelude
      t.datetime :go_live_date

      t.timestamps
    end
  end
end
