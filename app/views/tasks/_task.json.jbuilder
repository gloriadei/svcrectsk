json.extract! task, :id, :starttime, :duration, :jobid, :postedforpickup, :created_at, :updated_at
json.url task_url(task, format: :json)