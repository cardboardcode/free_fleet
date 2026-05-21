ARG ROS_DISTRO=jazzy
FROM cardboardcode/rmf:$ROS_DISTRO-ros-core
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    ros-$ROS_DISTRO-tf-transformations \
    cmake \
  && pip3 install flask-socketio fastapi uvicorn nudged rosbags pycdr2 eclipse-zenoh==1.5.0 --break-system-packages \
  && rm -rf /var/lib/apt/lists/*

# Copy in the fleet_adapter_tb3 ROS2 package.
WORKDIR /free_fleet_adapter_ws
COPY free_fleet src/free_fleet
COPY free_fleet_adapter src/free_fleet_adapter

# Compile the ROS 2 package.
RUN . /opt/ros/$ROS_DISTRO/setup.sh \
  && colcon build --mixin clang lld --merge-install --cmake-args -DCMAKE_BUILD_TYPE=Release

# Add sourcing statement to /ros_entrypoint.sh
RUN sed -i '$isource "/free_fleet_adapter_ws/install/setup.bash"' /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

