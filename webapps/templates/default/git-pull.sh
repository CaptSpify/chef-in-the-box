#!/bin/bash
cd /var/www
RESULT=$((git pull) 2>&1 | tee /var/log/www-pull.log )
if [[ "$RESULT" == error* ]] ; then
	echo "need to reset to head"
        git reset --hard origin/master;
        git pull
fi
if [[ "$RESULT" == *error* ]] ; then
	echo "need to reset to head"
        git reset --hard origin/master;
        git pull
fi

RESULT=$((git pull) 2>&1 | tee /var/log/www-pull.log )
if [[ "$RESULT" == error* ]] ; then
	echo "need to reset to head"
        git reset --hard origin/master;
        git pull
fi
if [[ "$RESULT" == *error* ]] ; then
	echo "need to reset to head"
        git reset --hard origin/master;
        git pull
fi
