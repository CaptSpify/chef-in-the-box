#
# Cookbook Name:: cron
# Attribute File:: default
#

default['cron']['scripts'] = ['17 *  * * * root    cd / && run-parts --report /etc/cron.hourly','25 6  * * * root  test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )','47 6  * * 7 root  test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )','52 6  1 * * root  test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )']
