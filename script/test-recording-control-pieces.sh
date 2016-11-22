#!/bin/sh
db="recordingtasks_production"
logger -s -t RecordingControl "From environment variables: $RECORDINGTASKS_PRODUCTION_PASSWORD"
export PGPASSWORD=$RECORDINGTASKS_PRODUCTION_PASSWORD
query="/usr/local/bin/psql -Uushers -q -t -d $db -c "
test1="starttime > CURRENT_TIMESTAMP"
test2="CURRENT_TIMESTAMP + INTERVAL '1 HOUR' >= starttime"
test3="pickedup is NULL"
data=($($query "select id, starttime, duration, jobid from tasks where $test1 and $test2 and $test3 ORDER BY starttime ASC LIMIT 1;"))
#
logger -s -t RecordingControl "RecordingControl Query Effort:"
logger -s -t RecordingControl "RecordingControl Condition #1: $test1"
logger -s -t RecordingControl "RecordingControl Condition #2: $test2"
logger -s -t RecordingControl "RecordingControl Condition #3: $test3"
logger -s -t RecordingControl "RecordingControl Full Query String is: $query \"select id, starttime, duration, jobid from tasks where $test1 and $test2 and $test3 ORDER BY starttime ASC LIMIT 1;\""
logger -s -t RecordingControl "RecordingControl >>${data[@]}<<"

