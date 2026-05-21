#!/usr/bin/env bash

CONFIG_FILE="/free_fleet_adapter_ws/config.yaml"
NAV_GRAPH_FILE="/free_fleet_adapter_ws/nav_graph.yaml"
TRAJECTORY_SERVER_URL="ws://localhost:8000/_internal"

docker run --rm \
	--name free_fleet_adapter_c \
	--network host \
	-e RCL_LOG_LEVEL=debug \
	-e RCUTILS_COLORIZED_OUTPUT=1 \
	-e RMW_IMPLEMENTATION=rmw_cyclonedds_cpp \
	-v ./free_fleet_examples/config/fleet/nav2_tb3_simulation_fleet_config.yaml:$CONFIG_FILE \
    -v ./free_fleet_examples/maps/turtlebot3_world/nav_graphs/0.yaml:$NAV_GRAPH_FILE \
free_fleet_adapter:jazzy bash -c \
"source /ros_entrypoint.sh && \
ros2 launch free_fleet_adapter fleet_adapter.launch.xml \
config_file:=$CONFIG_FILE \
nav_graph_file:=$NAV_GRAPH_FILE \
server_uri:=$TRAJECTORY_SERVER_URL"


