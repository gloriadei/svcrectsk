require 'test_helper'

class ServiceTimesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service_time = service_times(:one)
  end

  test "should get index" do
    get service_times_url
    assert_response :success
  end

  test "should get new" do
    get new_service_time_url
    assert_response :success
  end

  test "should create service_time" do
    assert_difference('ServiceTime.count') do
      post service_times_url, params: { service_time: { duration_of_recording: @service_time.duration_of_recording, go_live_date: @service_time.go_live_date, minutes_of_prelude: @service_time.minutes_of_prelude, service_start_time: @service_time.service_start_time } }
    end

    assert_redirected_to service_time_url(ServiceTime.last)
  end

  test "should show service_time" do
    get service_time_url(@service_time)
    assert_response :success
  end

  test "should get edit" do
    get edit_service_time_url(@service_time)
    assert_response :success
  end

  test "should update service_time" do
    patch service_time_url(@service_time), params: { service_time: { duration_of_recording: @service_time.duration_of_recording, go_live_date: @service_time.go_live_date, minutes_of_prelude: @service_time.minutes_of_prelude, service_start_time: @service_time.service_start_time } }
    assert_redirected_to service_time_url(@service_time)
  end

  test "should destroy service_time" do
    assert_difference('ServiceTime.count', -1) do
      delete service_time_url(@service_time)
    end

    assert_redirected_to service_times_url
  end
end
