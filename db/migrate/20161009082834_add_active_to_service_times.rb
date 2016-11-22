class AddActiveToServiceTimes < ActiveRecord::Migration[5.0]
  def change
    add_column :service_times, :active, :boolean
  end
end
