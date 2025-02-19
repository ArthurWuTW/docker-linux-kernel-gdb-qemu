HOST_USER=$(whoami)
PASSWD_USER_BY_SPACE=$(cat /etc/passwd | grep ${HOST_USER} | sed 's/:/ /g')
PASSWD_USER_ARR=($PASSWD_USER_BY_SPACE)
export HOSTUSER=${HOST_USER}
export HOSTUID=${PASSWD_USER_ARR[2]}
export HOSTGID=${PASSWD_USER_ARR[3]}

docker-compose ps
