#start nedi from crontab. Creates logfiles
opts="-pob"
CMD="./nedi.pl $opts"
LOGPATH="/var/log/nedi"
LOGFILE="$LOGPATH/nedi.log"
LASTRUN="$LOGPATH/lastrun.log"
cd /var/nedi
now=`date +%Y%m%d:%H%M`
echo "#$now start # $CMD" > $LASTRUN
echo "#$now start" >> $LOGFILE
$($CMD >> $LASTRUN)
tail -8 $LASTRUN >> $LOGFILE
now=`date +%Y%m%d:%H%M`
echo "#$now stop" >> $LOGFILE
echo "#$now stop" >> $LASTRUN'
