class ServiceTimesController < ApplicationController
  before_action :set_service_time, only: [:show, :edit, :update, :destroy]

  # GET /service_times
  # GET /service_times.json
  def index
    @service_times = ServiceTime.all
  end

  # GET /service_times/1
  # GET /service_times/1.json
  def show
  end

  # GET /service_times/new
  def new
    @service_time = ServiceTime.new
  end

  # GET /service_times/1/edit
  def edit
  end

  # POST /service_times
  # POST /service_times.json
  def create
    @service_time = ServiceTime.new(service_time_params)

    respond_to do |format|
      if @service_time.save
        format.html { redirect_to @service_time, notice: 'Service time was successfully created.' }
        format.json { render :show, status: :created, location: @service_time }
      else
        format.html { render :new }
        format.json { render json: @service_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_times/1
  # PATCH/PUT /service_times/1.json
  def update
    respond_to do |format|
      if @service_time.update(service_time_params)
        format.html { redirect_to @service_time, notice: 'Service time was successfully updated.' }
        format.json { render :show, status: :ok, location: @service_time }
      else
        format.html { render :edit }
        format.json { render json: @service_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_times/1
  # DELETE /service_times/1.json
  def destroy
    @service_time.destroy
    respond_to do |format|
      format.html { redirect_to service_times_url, notice: 'Service time was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_time
      @service_time = ServiceTime.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_time_params
      params.require(:service_time).permit(:service_start_time, :duration_of_recording, :minutes_of_prelude, :go_live_date)
    end
end
