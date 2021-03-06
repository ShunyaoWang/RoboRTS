#!/bin/bash

echo "RoboRTS v0.5"

function ProcessDetection() {
    ps_out=`ps -ef | grep $1 | grep -v 'grep' | grep -v $0`
    result=$(echo $ps_out | grep "$1")
    if [[ "$result" != "" ]];then
        return 1
    else
        return 0
    fi
}

gnome-terminal --window -e 'bash -c "roslaunch ${ROBORTS_PATH}/tools/stage/simulator.launch;exec bash"' \
ProcessDetection simulator.launch
rst=$?
while [ "$rst" = "0" ]; do
    ProcessDetection simulator.launch
    rst=$?
    sleep 1
done

gnome-terminal --window -e 'bash -c "cd ${ROBORTS_PATH};./build/modules/perception/localization/localization_node;exec bash"' \
gnome-terminal --window -e 'bash -c "cd ${ROBORTS_PATH};./build/modules/planning/global_planner/global_planner_node;exec bash"' \
gnome-terminal --window -e 'bash -c "cd ${ROBORTS_PATH};./build/modules/planning/local_planner/local_planner_node;exec bash"' \
gnome-terminal --window -e 'bash -c "cd ${ROBORTS_PATH};./build/modules/decision/decision_node;exec bash"'