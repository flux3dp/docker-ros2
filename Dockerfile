FROM ros:dashing-ros-base
LABEL maintainer="jeff@flux3dp.com"

RUN apt update && apt upgrade -yq

RUN apt install -yq python3-argcomplete python3-colcon-common-extensions libboost-system-dev
RUN mkdir -p ~/turtlebot3_ws/src
RUN cd ~/turtlebot3_ws/src && git clone -b ros2 https://github.com/ROBOTIS-GIT/hls_lfcd_lds_driver.git
RUN cd ~/turtlebot3_ws/src && git clone -b ros2 https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
RUN cd ~/turtlebot3_ws/src && git clone -b ros2 https://github.com/ROBOTIS-GIT/turtlebot3.git
RUN cd ~/turtlebot3_ws/src && git clone -b ros2 https://github.com/ROBOTIS-GIT/DynamixelSDK.git
RUN rm -r ~/turtlebot3_ws/src/turtlebot3/turtlebot3_cartographer
RUN rm -r ~/turtlebot3_ws/src/turtlebot3/turtlebot3_navigation2
RUN echo 'source /opt/ros/dashing/setup.bash' >> ~/.bashrc
RUN /bin/bash -c "cd ~/turtlebot3_ws && source /opt/ros/dashing/setup.bash && colcon build --symlink-install --parallel-workers 1"

# Domain ID Allocation
RUN echo 'source ~/turtlebot3_ws/install/setup.bash' >> ~/.bashrc
RUN echo 'export ROS_DOMAIN_ID=30 #TURTLEBOT3' >> ~/.bashrc

# OpenCR Setup
RUN dpkg --add-architecture armhf
RUN apt-get update
RUN apt-get install -yq libc6:armhf
RUN apt-get install -yq wget
RUN cd ~/ && wget https://github.com/ROBOTIS-GIT/OpenCR-Binaries/raw/master/turtlebot3/ROS2/latest/opencr_update.tar.bz2
RUN cd ~/ && tar -xjf ./opencr_update.tar.bz2
RUN cd ~/ && rm -rf opencr_update.tar.bz2

RUN echo 'export TURTLEBOT3_MODEL=waffle_pi' >> ~/.bashrc

# Custom Packages
RUN apt-get install -yq vim

# Setup entrypoint
COPY ./entrypoint.sh /root/entrypoint.sh

WORKDIR /root/

ENTRYPOINT ["/bin/bash", "/root/entrypoint.sh"]
CMD ["bash"]

