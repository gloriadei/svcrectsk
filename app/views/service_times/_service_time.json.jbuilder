json.extract! service_time, :id, :service_start_time, :duration_of_recording, :minutes_of_prelude, :go_live_date, :created_at, :updated_at
json.url service_time_url(service_time, format: :json)