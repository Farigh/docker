#! /bin/bash

resolved_script_path=$(readlink -f "$0")
current_script_dir=$(dirname "${resolved_script_path}")
current_full_path=$(readlink -e "${current_script_dir}")

# TODO: use getopts
option1=$1
option2=$2
docker_image_name=farigh/gitlab-ci-cpp-agent
docker_name=gitlab-cpp-agent

docker_mount_dir="${current_full_path}/shared"

# Devel mode, use local image
if [ "$option1" == "-d" ] || [ "$option2" == "-d" ]; then
	docker_image_name=gitlab-ci-cpp-agent
fi

# Share docker sock file
docker_run_opt="-v /var/run/docker.sock:/var/run/docker.sock"

# Share config dir
config_mount_dir="${docker_mount_dir}/config/"
docker_run_opt="-v ${config_mount_dir}:/etc/gitlab-runner ${docker_run_opt}"

# Set instance name and image
docker_run_opt="${docker_run_opt} --name ${docker_name} ${docker_image_name}"

RESET_COLOR=$(echo -en '\e[0m')
RED_COLOR=$(echo -en '\e[0;31m')
CYAN_COLOR=$(echo -en '\e[0;36m')

docker_ps=$(docker ps -af "name=${docker_name}" --format "{{.Names}}" | grep "^${docker_name}$")
if [ "${docker_ps}" != "${docker_name}" ]; then
    docker run $docker_run_opt
elif [ "$option1" == "-f" ] || [ "$option2" == "-f" ]; then
   if [ "$(docker inspect -f {{.State.Running}} ${docker_name} 2>/dev/null)" == "true" ]; then
       docker stop $docker_name
   fi
   docker rm $docker_name 2>/dev/null
   docker run $docker_run_opt
else
    if [ "$(docker inspect -f {{.State.Running}} ${docker_name} 2>/dev/null)" != "true" ]; then
        docker start $docker_name
    else
        echo "${RED_COLOR}Error: container '$docker_name' is already running${RESET_COLOR}"
        exit 1
    fi
fi
