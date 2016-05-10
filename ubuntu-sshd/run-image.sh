#! /bin/bash

resolved_script_path=`readlink -f $0`
current_script_dir=`dirname $resolved_script_path`
current_full_path=`readlink -e $current_script_dir`

option=$1
docker_image_name=ubuntu-sshd
docker_name=ubuntu_sshd_docker
docker_home_dir="$current_full_path/home"
host_port=24042
# NET_ADMIN capability needed by iptables
docker_run_opt="--cap-add=NET_ADMIN -d -p ${host_port}:22 --name ${docker_name} ${docker_image_name}"

RESET_COLOR=$(echo -en '\e[00m')
RED_COLOR=$(echo -en '\e[0;31m')
CYAN_COLOR=$(echo -en '\e[0;36m')

# Add volume mounting option if dir exixsts
if [ -d "$docker_home_dir" ]; then
    docker_run_opt="-v ${docker_home_dir}:/home/sshuser ${docker_run_opt}"
    echo "${CYAN_COLOR}Info: mounting dir '$docker_home_dir' as container's user home dir${RESET_COLOR}"
fi

docker_ps=`docker ps -a | grep $docker_name`
if [ "$docker_ps" == "" ]; then
    docker run $docker_run_opt
elif [ "$option" == "-f" ]; then
   if [ "$(docker inspect -f {{.State.Running}} ${docker_name})" == "true" ]; then
       docker stop $docker_name
   fi
   docker rm $docker_name
   docker run $docker_run_opt
else
    if [ "$(docker inspect -f {{.State.Running}} ${docker_name})" != "true" ]; then
        docker start $docker_name
    else
        echo "${RED_COLOR}Error: container '$docker_name' is already running${RESET_COLOR}"
        exit 1
    fi
fi
