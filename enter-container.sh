HOST_USER=$(whoami)
PASSWD_USER_BY_SPACE=$(cat /etc/passwd | grep ${HOST_USER} | sed 's/:/ /g')
PASSWD_USER_ARR=($PASSWD_USER_BY_SPACE)
export HOSTUSER=${HOST_USER}
export HOSTUID=${PASSWD_USER_ARR[2]}
export HOSTGID=${PASSWD_USER_ARR[3]}

arr=(` docker-compose ps | awk 'NR>1 {split($0,arr," "); print arr[1]}' `)
echo "#######################################################"
echo "Which container you want to enter?"
for((i=0;i<${#arr[@]};i++));
do
    echo "$i. ${arr[i]}"
done

while true 
do
    read -p "Index: " ind

    if [ ! -z "${arr[ind]}" ] && [ $ind -ge 0 ];
    then
        echo "you are going to enter ${arr[ind]}"
        break
    else
        echo "Key wrong syntax"
    fi
done

docker exec \
    --env TERM=xterm-256color \
    --interactive \
    --tty \
    ${arr[ind]} \
    bash -c "cd /home && /bin/bash -l"
