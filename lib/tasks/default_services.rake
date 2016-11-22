namespace :default_services do
  require 'active_support'

  desc "List default worship service times."
  task :list => :environment do
    defaults = ServiceTime.where('active = TRUE and go_live_date <= CURRENT_DATE')
    defaults.each_with_index do |df, idx|
      print idx + 1, ": "
      print "#{df.minutes_of_prelude} minutes of prelude prior to service starting at "
      print df.service_start_time.strftime("%H:%M"), " for #{df.duration_of_recording} minutes."
      print "\n"
    end
  end


  desc "Generate worship recordings based off of default service schedules"
  task :generate => :environment do
    defaults = ServiceTime.where('active = TRUE and go_live_date <= CURRENT_DATE')
    if defaults.count == 0
      # email administrator?
      # exit with an error?
      puts "Caution: No default service recording times are current and active."
    else
      puts "Default service recordings found: #{defaults.count}"
      defaults.each_with_index do |df, idx|
	      print idx + 1, ": "
        print "#{df.minutes_of_prelude} minutes of prelude prior to service starting at "
	      print df.service_start_time.strftime("%H:%M"), " for #{df.duration_of_recording} minutes."
        print "\n" 
      end
    end
    
    manuals = Task.where('(starttime >= ?) and (starttime < ?)', Date.today, Date.tomorrow)
    if manuals.count == 0
      puts "No conflicts of any kind... moving to generate manuals based upon stored default service times."
      # no conflicts nor overlaps to worry about: Generate manuals based upon defaults
      defaults.each do |df|
#        dfstarttime = df.service_start_time.strftime("%H%M")
#        dfstart = Date.today.strftime("%Y-%m-%d")
#        jobid = dfstart + "-" + dfstarttime
        # need to create a Date object that we can subtract the prelude time from...
        # this provides correct date-time math in case a service starttime is midnight
#        dfY = Date.today.strftime("%Y").to_i
#        dfM = Date.today.strftime("%m").to_i
#        dfD = Date.today.strftime("%d").to_i
#        dfH = df.service_start_time.strftime("%H").to_i
#        dfm = df.service_start_time.strftime("%M").to_i
#        dfDateTime = DateTime.new(dfY, dfM, dfD, dfH, dfm)
#        starttime = (dfDateTime.to_time - df.minutes_of_prelude.minutes).to_datetime
#        tn = Task.new(:starttime => starttime, :duration => df.duration_of_recording, :jobid => jobid) 
        tn = taskFromDefault(df)
        tn.save
      end
    else
      # Recording_Control_V3.3 and earlier record from the control job, so there is only one
      # recording at a time possile.  This means any earlier recording will "win" prior to pickup
      defaults.each do |df|
	#     puts df
        # Discard the irrelevant Date portion of the default service start time
	      dfstarttime = df.service_start_time.strftime("%H%M")
	      # So we'll add this default start time to today's date which is...
	      dfstart = Date.today.strftime("%Y-%m-%d")
              # Recording starts at dfstarttime - minutes_of_prelude
              recstarttime = df.service_start_time - df.minutes_of_prelude * 60
              recstarttime_str = recstarttime.strftime("%H%M")
	      puts "Looking at a default that is supposed to start on #{dfstart} at #{recstarttime_str}."
#              puts "Because the prelude is #{df.minutes_of_prelude} minutes, recording would start at #{recstarttime_str}"
        drst = defaultRecordingStartTime(df)
        dret = defaultRecordingEndTime(df)
        manuals.each do |mn|
          mnstart = mn.jobid.split("_").first
          mnstarttime = DateTime.strptime(mnstart, "%Y-%m-%d-%H%M")
          if ( mnstarttime == dfstarttime ) 
            # We have a conflict
#            puts "manual starts at the same time as a default."
            if mn.duration == df.duration_of_recording
              # We have an exact match
              puts "This default matches a manually requested recording in both start time and duration, so we'll skip over this default service recording."
            else
              if mn.duration > df.duration_of_recording
                puts "A manually requested recording starts when a default service recording would start, and lasts longer than the default service recording specifies, so we're skipping the default service recording."
              else
                puts "A manually requested recording starts when a default service recording would start, but isn't scheduled to record for as long as we would by default.  Please investigate what is the right duration to record.  We are leaving the manually defined duration alone."
              end
            end
          else # check for overlaps
            aTask = taskFromDefault(df)
            puts "New task from this default would look like:\nStart Time: #{aTask.starttime}\nDuration: #{aTask.duration}\nJobID: #{aTask.jobid}"
            puts "Such a task would have an endtime of #{defaultRecordingEndTime(df)}"
          end
        end
      end
    end
  end
  
  def taskFromDefault(aDefault)
    dfstarttime = aDefault.service_start_time.strftime("%H%M")
    dfstart = Date.today.strftime("%Y-%m-%d")
    jobid = dfstart + "-" + dfstarttime
    return Task.new(:starttime => defaultRecordingStartTime(aDefault), :duration => aDefault.duration_of_recording, :jobid => jobid)
  end
  
  def compareDefaultToManual(aDefault, aManual)
    return "No Conflict" if defaultRecordingEndTime(aDefault) < manualRecordingStartTime(aManual)
    return "No Conflict" if manualRecordingEndTime(aManual) < defaultRecordingStartTime(aDefault)
    return "Conflict"
  end
  
  def manualRecordingStartTime(aManual)
    return aManual.starttime
  end
  
  def defaultRecordingStartTime(aDefault)
    dfstarttime = aDefault.service_start_time.strftime("%H%M")
    dfstart = Date.today.strftime("%Y-%m-%d")
    jobid = dfstart + "-" + dfstarttime
    # need to create a Date object that we can subtract the prelude time from...
    # this provides correct date-time math in case a service starttime is midnight
    dfY = Date.today.strftime("%Y").to_i
    dfM = Date.today.strftime("%m").to_i
    dfD = Date.today.strftime("%d").to_i
    dfH = aDefault.service_start_time.strftime("%H").to_i
    dfm = aDefault.service_start_time.strftime("%M").to_i
    dfDateTime = DateTime.new(dfY, dfM, dfD, dfH, dfm)
    starttime = (dfDateTime.to_time - aDefault.minutes_of_prelude.minutes).to_datetime
    return starttime
  end
  
  def manualRecordingEndTime(aManual)
    return (aManual.starttime + aManual.duration.minutes).to_datetime
  end
  
  def defaultRecordingEndTime(aDefault)
    starttime = defaultRecordingStartTime(aDefault)
    endTime = (starttime + aDefault.duration_of_recording.minutes).to_datetime
    return endTime
  end
  
end
