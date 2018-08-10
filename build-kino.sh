#!/bin/bash
#
# Created by Remi LICHIERE <remi.lichiere@visiativ.com>

set -e
set -x

ROLE=$1
REDIS_HOST=192.168.0.200
DOMAIN_NAME=kino


install_docker() {
	apt-get install apt-transport-https ca-certificates -y
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
	apt-get update
	# Install Docker Engine
	apt-get install -y --no-install-recommends docker-engine
	# Add Moovapps Docker Registry and Expose Docker API
	echo 'DOCKER_OPTS="-H unix:///var/run/docker.sock   -H tcp://0.0.0.0:4243 --insecure-registry dregistry.visiativ.moovapps.com"' >> /etc/default/docker
	# Add vagrant to docker group
	gpasswd -a vagrant docker
	# Restart Docker
	service docker restart
}

install_docker_compose(){
	# Download Docker Compose bin
	curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
}

prepare_vm(){
	install_docker
	install_docker_compose
}

# Main Entry

# Run common Tasks
prepare_vm

# Run Spec Tasks
case $ROLE in
	'manager')
		#Install and configure nfs
		apt-get install -y nfs-kernel-server
		echo '/data/share      192.168.0.0/24(rw,no_subtree_check,async,no_root_squash)' >> /etc/exports
		service nfs-kernel-server restart

 		# Build Provisioning Dev Env
		#Just for dev Env (internet sucks)
		mkdir -p /vagrant/docker_images
		declare -a docker_img_to_laod=("ubuntu:14.04" "dregistry.visiativ.moovapps.com/mysql-prod:5.6" "phpmyadmin/phpmyadmin")
		for img in "${docker_img_to_laod[@]}"
        do
            img_filename=$(echo $img | cut -d '/' -f 2 | sed -r 's/[:]+/-/g')
            if [[ -f "/vagrant/docker_images/${img_filename}.tar.gz" ]]; then
				docker load < "/vagrant/docker_images/${img_filename}.tar.gz"
			else
				docker pull $img
				docker save $img > "/vagrant/docker_images/${img_filename}.tar.gz"
			fi
        done
		# Launch dev Environment
		docker-compose -f /vagrant/docker-compose.yml up -d --build

	;;
	*)
		echo 'invalid role'
	;;
esac
