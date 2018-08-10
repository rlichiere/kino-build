#!/bin/bash
#
# Created by Remi LICHIERE <remi.lichiere@visiativ.com>

DEFAULT_LOG_LEN=200
DEFAULT_CONTAINER_NAME=vagrant_app_1

OPT1=$1
OPT2=$2
OPT3=$3
echo ''
case $OPT1 in
   '--help')
      echo 'restart [<Group>] [<Attached Container>] [<Log tail>]'
      echo ''
	  echo 'Description:'
      echo '   Restart (Stop then Start) selected containers.'
	  echo ''
      echo 'Options:'
      echo '   Group : group of containers to be restarted.'
      echo '      <empty>     restart only main app container : django app'
      echo '      kino        restart kino containers : django app and dbkino'
      echo '      all         restart all containers'
      echo ''
      echo '   Attached container : Short name of container to attach after job'
      echo '      <empty>     vagrant_app_1'
      echo '      db          vagrant_dbkino_1'
      echo '      php         vagrant_phpmyadmin_1'
      echo ''
      echo '   Log tail : Number of tailed logs'
      echo '      <empty>     Use default value :' $DEFAULT_LOG_LEN
      echo '      <number>    Number of tailed logs'
      echo '      -d          Detach'
	  echo ''
	  echo 'Examples:'
	  echo '   sh restart.sh                  # Restarts app     and attach to app        with' $DEFAULT_LOG_LEN 'logs'
	  echo '   sh restart.sh kino             # Restarts kino    and attach to app        with' $DEFAULT_LOG_LEN 'logs'
	  echo '   sh restart.sh all              # Restarts all     and attach to app        with' $DEFAULT_LOG_LEN 'logs'
	  echo '   sh restart.sh kino db          # Restarts kino    and attach to task       with' $DEFAULT_LOG_LEN 'logs'
	  echo '   sh restart.sh kino php         # Restarts kino    and attach to phpmyadmin with' $DEFAULT_LOG_LEN 'logs'
	  echo '   sh restart.sh 100              # Restarts app     and attach to app        with 100 logs'
	  echo '   sh restart.sh kino 100         # Restarts kino    and attach to app        with 100 logs'
	  echo '   sh restart.sh db 100           # Restarts app     and attach to db         with 100 logs'
	  echo '   sh restart.sh kino db 100      # Restarts kino    and attach to db         with 100 logs'
	  echo '   sh restart.sh -d               # Restarts app     and detach'
	  echo '   sh restart.sh kino -d          # Restarts kino    and detach'
	  echo ''
      exit
   ;;
esac

MODE=$OPT1
OPT_CONTAINER=$OPT2
OPT_LOG_LEN=$OPT3

echo ''
echo '___________________________________'
echo 'OPTION : <Group> '
case $OPT1 in
    'kino')
        COUNT=2
        echo 'Use group :' $OPT1
        echo $COUNT 'containers :'
        echo '  - vagrant_app_1'
        echo '  - vagrant_dbkino_1'
    ;;
    'all')
        COUNT=3
        echo 'Use group :' $OPT1
        echo $COUNT 'containers :'
        echo '  - vagrant_app_1'
        echo '  - vagrant_dbkino_1'
        echo '  - vagrant_phpmyadmin_1'
    ;;
    '')
        COUNT=1
        #echo 'Treated <empty>'
        echo 'Empty. Use default group.'
        echo $COUNT 'targets :'
        echo '  - vagrant_app_1'
        MODE='default'
        OPT_CONTAINER=''
        #OPT_LOG_LEN=$DEFAULT_LOG_LEN
    ;;
    '-d')
        #echo 'Treated -d'
        echo 'Empty. Use default group.'
        COUNT=1
        echo $COUNT 'targets :'
        echo '  - vagrant_app_1'
        MODE='default'
        OPT_CONTAINER='-d'
        OPT_LOG_LEN='-d'
    ;;
    *)
        COUNT=1
        #echo 'Treated * :' $OPT1
        echo 'Empty. Use default group.'
        echo $COUNT 'targets :'
        echo '  - vagrant_app_1'
        MODE=default
        OPT_CONTAINER=$OPT1
        OPT_LOG_LEN=$OPT2
    ;;
esac
echo ''

echo '___________________________________'
echo 'OPTION : <Attached container>'
case $OPT_CONTAINER in
    'db')
        ATTACHED_CONTAINER=vagrant_dbkino_1
    ;;
    'php')
        ATTACHED_CONTAINER=vagrant_phpmyadmin_1
    ;;
    '')
        echo 'Empty. Use default container name.'
        OPT_CONTAINER='default'
        ATTACHED_CONTAINER=$DEFAULT_CONTAINER_NAME
        #OPT_LOG_LEN=$DEFAULT_LOG_LEN
    ;;
    '-d')
        #echo 'Treated <empty> -d'
        #echo 'Use default container name.'
        echo 'Empty. Use default container name.'
        #OPT_CONTAINER='-d'
        #ATTACHED_CONTAINER='-d'
        OPT_CONTAINER=''
        ATTACHED_CONTAINER=''
        OPT_LOG_LEN='-d'
    ;;
    *)
        #echo 'Delegated :' $OPT_CONTAINER
        #echo 'Use default container name.'
        echo 'Empty. Use default container name.'
        ATTACHED_CONTAINER=$DEFAULT_CONTAINER_NAME
        OPT_LOG_LEN=$OPT_CONTAINER
        OPT_CONTAINER='default'
    ;;
esac
echo 'Use container :' $ATTACHED_CONTAINER
echo ''

echo '___________________________________'
echo 'OPTION : <Log tail> '
case $OPT_LOG_LEN in
    '')
        echo 'Empty. Use default log tail.'
        OPT_LOG_LEN='default'
        LOG_LEN=$DEFAULT_LOG_LEN
    ;;
    '-d')
        echo 'Empty. Use default log tail.'
        LOG_LEN=''
    ;;
    *)
        echo 'Use log tail :' $OPT_LOG_LEN
        LOG_LEN=$OPT_LOG_LEN
    ;;
esac
echo ''

echo '___________________________________'
echo 'OVERVIEW'
echo 'Group                  :' $MODE
echo '  Number of containers :' $COUNT
case $LOG_LEN in
    '')
        echo 'Log                    : Detach'
    ;;
    *)
        echo 'Attach to              :' $ATTACHED_CONTAINER
        echo '  With tail            :' $LOG_LEN
    ;;
esac
echo ''

echo '___________________________________'
echo 'CONFIRMATION'
while true; do
    read -p 'Do you really want to apply restart ? ([y]/n) : ' yn
    case $yn in
        [Yy]*)
            echo 'Restart explicitely confirmed by user.'
            APPLY_RESTART='yes'
            break
        ;;
        '')
            echo 'Restart implicitely confirmed by user.'
            APPLY_RESTART='yes'
            break
        ;;
        [Nn]*)
            echo 'Restart canceled by user.'
            APPLY_RESTART='no'
            break
        ;;
        *)
            echo 'Please answer yes or no'
        ;;
    esac
done;
echo ''

case $APPLY_RESTART in
    'yes')
        echo '___________________________________'
        echo 'APPLY'
        echo 'Stop containers...'
        case $MODE in
            'all')
                docker stop vagrant_app_1
                docker stop vagrant_dbkino_1
                docker stop vagrant_phpmyadmin_1
            ;;
            'kino')
                docker stop vagrant_app_1
                docker stop vagrant_dbkino_1
            ;;
            'default')
                docker stop vagrant_app_1
            ;;
        esac
        echo 'Containers stopped.'
        echo 'Start containers...'

        case $MODE in
            'all')
                docker start vagrant_phpmyadmin_1
                docker start vagrant_dbkino_1
                docker start vagrant_app_1
            ;;
            'kino')
                docker start vagrant_dbkino_1
                docker start vagrant_app_1
            ;;
            'default')
                docker start vagrant_app_1
            ;;
        esac
        echo 'Containers started.'
        echo ''
    ;;
    *)
    ;;
esac

case $LOG_LEN in
    '')
        echo '___________________________________'
        echo 'DETACH'
        echo 'Detached.'
    ;;
    *)
        echo '___________________________________'
        echo 'ATTACH'
        echo 'Attach to container :' $ATTACHED_CONTAINER
        echo 'With tail :' $LOG_LEN
        docker logs --tail $LOG_LEN -f $ATTACHED_CONTAINER
        echo 'Attached.'
    ;;
esac
echo ''
