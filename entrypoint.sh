#!/bin/bash
set -e

source /opt/ros/dashing/setup.bash
source ~/turtlebot3_ws/install/setup.bash
export TURTLEBOT3_MODEL=waffle_pi
export ROS_DOMAIN_ID=30 #TURTLEBOT3

export OPENCR_PORT=/dev/ttyACM0
export OPENCR_MODEL=waffle
cd ~/opencr_update && ./update.sh $OPENCR_PORT $OPENCR_MODEL.opencr && cd ~

sleep 15 # wait until opencr_update take effect

ros2 launch turtlebot3_bringup robot.launch.py

exec "$@"