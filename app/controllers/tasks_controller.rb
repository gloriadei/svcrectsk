class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all.order( 'starttime DESC' )
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

    def status
      fn = currentTimerFile
      if fn.count == 1
	fd = File.new(fn.first,"r")
        @identifier = fn.first
        session[:identifier] = fn.first
        Rails.logger.debug { "The filename we're trying to pass long is >>#{@identifier}<<"}
	@remaining = fd.gets
      else
	@remaining = "idle."
      end 
        logger.warn "Remaining seconds are #{@remaining}"
        refreshable = @remaining
    end

    def halt 
      # call this action to immediately halt a recording by setting the time remaining to zero seconds
      Rails.logger.debug { "Parameters hash returned to us looks like: #{params}"}
      Rails.logger.debug { "Session hash returned to us includes: >>#{session[:identifier]}<<"}
      id = "#{session[:identifier]}"
      fnTimer = currentTimerFile
      Rails.logger.debug { "Halt has been requested; currentTimerFile we need to write a zero into is #{fnTimer}" }
      if fnTimer.first == id
      #	if fnTimer.count == 1
	File.open(fnTimer.first, 'w') {|f| f.write("0\n")} # unless fnTimer.empty? #how can fnTimer be empty when we're here because the count of the array is 1?
      else
        Rails.logger.debug { "Figure this one out: we are hoping that >>#{id}<< (our id) was the first item in the array returned by our currentTimerFile routine, but it wasn't... it was >>#{fnTimer.first}<<" }
      end
    end

    def timer
      # This is the action item from the status action.  If you change the timer value on the status
      # page and hit the update button, this is the action that handles writing that value to our
      # timer file.
      fnTimer = currentTimerFile
      if fnTimer.count == 1
	  fnTimer = fnTimer.first
	  @identifier = fnTimer.split("/tmp/gdlc")[1].split(".txt").first
          # logger.debug { "---> About to write #{params[:timer]} to #{fnTimer} <---" }
          # foo = `echo #{params[:timer]} > #{fnTimer}`
          if isnumeric( params[:timer])
            @remaining = params[:timer].to_i * 60
            File.open(fnTimer, 'w') {|f| f.write(@remaining.to_s + "\n")}  
            redirect_to tasks_status_path
          end
      end
      # 
      # if ( params[:timer] == "0")
      #   @remaining = 0
      # else
      #   if ( params[:timer].to_i == 0 ) # then the value the user entered isn't really zero (see above)
      #     @remaining = params[:timer] = ""
      #   else
      #     @remaining = params[:timer].to_i
      #     File.open(fnTimer, 'w') {|f| f.write(@remaining.to_s + "\n")}
      #   end
      # end
    end
  
    def refreshable
      fnTimer = currentTimerFile
      if fnTimer.count == 1
        fnTimer = fnTimer.first
        @remaining = `cat #{fnTimer}`
      else
        @remaining = 0
      end    
      # 2015-01-21 log says :refreshable doesn't exist in the render, so let's switch to just using @remaining
      #   render :partial => "refreshable", :layout => false, :locals => { :refreshable => @remaining }
      render :partial => "refreshable", :layout => false, :locals => { :refreshable => @remaining }
    end
  
    private
  
    def currentTimerFile
	# This quick and dirty approach assumes there aren't two recordings going on at the same time, but
	# until we have a FireWire input device, I don't see how we can have two at the same time!
	fn = Dir.glob("/tmp/gdlc*.txt")	
	return fn
    end

    def isnumeric( foo )
      ( foo == foo.to_i.to_s)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:starttime, :duration, :jobid, :postedforpickup)
    end
end
