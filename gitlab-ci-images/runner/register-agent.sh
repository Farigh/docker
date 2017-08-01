#! /bin/bash
resolved_script_path=`readlink -f $0`
current_script_dir=`dirname $resolved_script_path`
current_full_path=`readlink -e $current_script_dir`

# TODO: use getopts
option1=$1
option2=$2
docker_image_name=farigh/gitlab-ci-runner
docker_name=gitlab-runner-configurator

docker_mount_dir="${current_full_path}/shared"

# Devel mode, use local image
if [ "$option1" == "-d" ] || [ "$option2" == "-d" ]; then
	docker_image_name=gitlab-ci-runner
fi

# Create shared config dir
config_mount_dir="${docker_mount_dir}/config/"
if [ ! -d "${config_mount_dir}" ]; then
    # create default tree
    mkdir -p "${config_mount_dir}"
    mkdir -p "${config_mount_dir}certs"
fi

# Create register.sh
echo "#! /bin/bash" > ${config_mount_dir}/register.sh
echo "echo 'Running configurator.....'" >> ${config_mount_dir}/register.sh
echo "gitlab-runner register" >> ${config_mount_dir}/register.sh
echo -e "\n\necho 'Generated content:'" >> ${config_mount_dir}/register.sh
echo "cat /etc/gitlab-runner/config.toml" >> ${config_mount_dir}/register.sh
chmod +x ${config_mount_dir}/register.sh

docker_run_opt="-v ${config_mount_dir}:/etc/gitlab-runner"

# Set instance name and image
docker_run_opt=" ${docker_run_opt} --name ${docker_name} ${docker_image_name}"

RESET_COLOR=$(echo -en '\e[00m')
RED_COLOR=$(echo -en '\e[0;31m')
CYAN_COLOR=$(echo -en '\e[0;36m')

docker_ps=`docker ps -a | grep $docker_name`
if [ "$docker_ps" != "" ]; then
   docker rm $docker_name 2>/dev/null
fi

docker run -it --entrypoint '/etc/gitlab-runner/register.sh' $docker_run_opt

# Cleanup
docker rm $docker_name 2>/dev/null
rm ${config_mount_dir}/register.sh