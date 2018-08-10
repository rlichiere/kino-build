#!/bin/bash
#
# Created by Remi LICHIERE <remi.lichiere@visiativ.com>

OPT1=$1
OPT2=$2

# Groups definitions
GROUP_DEFAULT='vagrant_app_1'
GROUP_KINO='vagrant_app_1 vagrant_dbkino_1'

GROUP_ALL='vagrant_app_1 vagrant_dbkino_1 vagrant_phpmyadmin_1'
GROUP_ALL_DOCKER=''

OPT_ATTACH=$OPT2

case $OPT1 in
    '--help')
        echo 'stats [<Group>] [<Detach>]'
        echo ''
        echo 'Description:'
        echo '   Shows containers statistics.'
        echo ''
        echo 'Options:'
        echo '   Group : group of containers to be monitored.'
        echo '      <empty>    show statistics for main container : django app'
        echo '      kino       show statistics for kino containers : django app and dbkino'
        echo '      all        show statistics for all containers'
        echo '      alldocker  show statistics for all docker containers'
        echo ''
        echo '   Attach : Show only one frame of statistics, or monitor continuously'
        echo '      <empty>    Attach: monitor containers continuously'
        echo '      -d         Detach: show only one frame of statistics'
        echo ''
        echo 'Examples:'
        echo '   sh docker_stats.sh           # monitor continuously app  statistics'
        echo '   sh docker_stats.sh kino      # monitor continuously kino statistics'
        echo '   sh docker_stats.sh -d        # show only 1 frame of app  statistics'
        echo '   sh docker_stats.sh kino -d   # show only 1 frame of kino statistics'
        echo ''
        exit
    ;;
esac


echo '______________________________'
echo 'OPTION : Group'
case $OPT1 in
    'kino')
        CONTAINER_LIST=$GROUP_KINO
    ;;
    'all')
        CONTAINER_LIST=$GROUP_ALL
    ;;
    'alldocker')
        CONTAINER_LIST=$GROUP_ALL_DOCKER
    ;;
    '')
        CONTAINER_LIST=$GROUP_DEFAULT
    ;;
    *)
        CONTAINER_LIST=$GROUP_DEFAULT
        OPT_ATTACH=$OPT1
    ;;
esac
echo 'Containers :' $CONTAINER_LIST
echo ''

echo '______________________________'
echo 'OPTION : Attach'

case $OPT_ATTACH in
    '')
        echo 'Monitor containers.'
        ATTACH=''
    ;;
    '-d')
        echo 'Show only one frame.'
        ATTACH='--no-stream'
    ;;
esac
echo ''

echo '______________________________'
echo 'OVERVIEW'
echo 'Containers :' $CONTAINER_LIST
echo 'Attach :' $ATTACH
echo ''

docker stats $CONTAINER_LIST --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}" $ATTACH
