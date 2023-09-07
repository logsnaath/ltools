
Terminal-1:
===========
plymouthd --debug --tty=`tty` --no-daemon

Terminal-2:
===========
plymouth --ping && echo plymouth is running || echo plymouth NOT running
plymouth show-splash
plymouth deactivate
plymouth reactivate
plymouth message --text="Hello world. Time: $(date)"
sleep 5
plymouth --quit


=====================
plymouth pause-progress
plymouth message --text="XXXXXXX"
plymouth unpause-progress

