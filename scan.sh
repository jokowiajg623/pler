#!/bin/bash
while true; do
    rm -f telnet.txt
    screen -dmS telnet bash -c 'sudo zmap -p23 -q 2> telnet.txt | python3 telnet.py'
    echo "Start"
    while true; do
        cond1=$(grep -q "\[INFO\] zmap: completed" telnet.txt 2>/dev/null && echo 1 || echo 0)
        screen -S telnet -X hardcopy -h /tmp/telnet_screen.log >/dev/null 2>&1
        cond2=$(tail -n 10 /tmp/telnet_screen.log | grep -q "Queue: 0" && echo 1 || echo 0)
        if [[ "$cond1" == "1" && "$cond2" == "1" ]]; then
            pkill -f telnet
            echo "End"
            break
        fi
        if ! pgrep -f zmap > /dev/null; then
            break
        fi
        sleep 60
    done
done
