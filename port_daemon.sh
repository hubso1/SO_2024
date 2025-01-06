#!/bin/bash

LOGILE="/var/log/port_monitor.log"
TIME=60

monitor() {
echo "$(date): Start monitorowania portów" >> "$LOGFILE"

    while true; do
        ss -tuln | grep LISTEN >> "$LOGFILE"
        echo "-----" >> "$LOGFILE"

        sleep "$TIME"
    done
}
monitor &

# sudo systemctl daemon-reload
# sudo systemctl start port-monitor.service
# tail -f /var/log/port_monitor.log
