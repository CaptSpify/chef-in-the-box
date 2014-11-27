#!/bin/sh

# ########################################################################
# This program is part of Percona Monitoring Plugins
# License: GPL License (see COPYING)
# Authors:
#  Baron Schwartz
# ########################################################################

# ########################################################################
# Redirect STDERR to STDOUT; Nagios doesn't handle STDERR.
# ########################################################################
exec 2>&1

# ########################################################################
# Set up constants, etc.
# ########################################################################
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4
EXITSTATUS=$STATE_UNKNOWN

# ########################################################################
# Run the program.
# ########################################################################
main() {
   # Get options
   for o; do
      case "${o}" in
         -c)              shift; OPT_CRIT="${1}"; shift; ;;
         --defaults-file) shift; OPT_DEFT="${1}"; shift; ;;
         -H)              shift; OPT_HOST="${1}"; shift; ;;
         -l)              shift; OPT_USER="${1}"; shift; ;;
         -p)              shift; OPT_PASS="${1}"; shift; ;;
         -P)              shift; OPT_PORT="${1}"; shift; ;;
         -S)              shift; OPT_SOCK="${1}"; shift; ;;
         -s)              shift; OPT_SRVID="${1}"; shift; ;;
         -T)              shift; OPT_TABLE="${1}"; shift; ;;
         -w)              shift; OPT_WARN="${1}"; shift; ;;
         --version)       grep -A2 '^=head1 VERSION' "$0" | tail -n1; exit 0 ;;
         --help)          perl -00 -ne 'm/^  Usage:/ && print' "$0"; exit 0 ;;
         -*)              echo "Unknown option ${o}.  Try --help."; exit 1; ;;
      esac
   done
   OPT_WARN=${OPT_WARN:-300}
   OPT_CRIT=${OPT_CRIT:-600}
   if [ -e '/etc/nagios/mysql.cnf' ]; then
      OPT_DEFT="${OPT_DEFT:-/etc/nagios/mysql.cnf}"
   fi

   # Get replication delay from a heartbeat table or from SHOW SLAVE STATUS.
   # TODO: support pt-heartbeat v1.0 table format.
   if [ "${OPT_TABLE}" ]; then
      SQL="SELECT MAX(UNIX_TIMESTAMP() - UNIX_TIMESTAMP(ts)) AS delay
         FROM ${OPT_TABLE} WHERE (${OPT_SRVID:-0} = 0 OR server_id = ${OPT_SRVID:-0})"
      LEVEL=$(mysql_exec "${SQL}")
      MYSQL_CONN=$?
   else
      local TEMP=$(mktemp "/tmp/${0##*/}.XXXX") || exit $?
      trap 'rm -rf "${TEMP}" >/dev/null 2>&1' EXIT
      mysql_exec 'SHOW SLAVE STATUS\G' > "${TEMP}"
      MYSQL_CONN=$?
      if [ "${MYSQL_CONN}" = 0 ]; then
         LEVEL=$(awk '/Seconds_Behind_Master/{print $2}' "${TEMP}")
      fi
   fi

   # Test whether the delay is too long.
   if [ "$MYSQL_CONN" = 0 ]; then
      NOTE="${LEVEL:-0} seconds of replication delay"
      if [ "${LEVEL:-0}" -gt "${OPT_CRIT}" ]; then
         EXITSTATUS=$STATE_CRITICAL
         NOTE="CRIT $NOTE"
      elif [ "${LEVEL:-0}" -gt "${OPT_WARN}" ]; then
         EXITSTATUS=$STATE_WARNING
         NOTE="WARN $NOTE"
      else
         EXITSTATUS=$STATE_OK
         NOTE="OK $NOTE"
      fi
   else
      EXITSTATUS=$STATE_UNKNOWN
      NOTE="UNK could not determine replication delay"
   fi
   echo $NOTE
   exit $EXITSTATUS
}

# ########################################################################
# Execute a MySQL command.
# ########################################################################
mysql_exec() {
   mysql ${OPT_DEFT:+--defaults-file="${OPT_DEFT}"} ${OPT_HOST:+-h"${OPT_HOST}"} ${OPT_USER:+-u"${OPT_USER}"} \
      ${OPT_PASS:+-p"${OPT_PASS}"} ${OPT_SOCK:+-S"${OPT_SOCK}"} ${OPT_PORT:+-P"${OPT_PORT}"} \
      -ss -e "$1"
}

# ########################################################################
# Execute the program if it was not included from another file.
# This makes it possible to include without executing, and thus test.
# ########################################################################
if    [ "${0##*/}" = "pmp-check-mysql-replication-delay.sh" ] \
   || [ "${0##*/}" = "bash" -a "$_" = "$0" ]; then
   main "$@"
fi

# ############################################################################
# Documentation
# ############################################################################
: <<'DOCUMENTATION'
=pod

=head1 NAME

pmp-check-mysql-replication-delay - Alert when MySQL replication becomes delayed.

=head1 SYNOPSIS

  Usage: pmp-check-mysql-replication-delay [OPTIONS]
  Options:
    -c CRIT         Critical threshold; default 600.
    --defaults-file FILE Only read mysql options from the given file.
                    Defaults to /etc/nagios/mysql.cnf if it exists.
    -H HOST         MySQL hostname.
    -l USER         MySQL username.
    -p PASS         MySQL password.
    -P PORT         MySQL port.
    -S SOCKET       MySQL socket file.
    -s SERVERID     MySQL server ID of master, if using pt-heartbeat table.
    -T TABLE        Heartbeat table used by pt-heartbeat.
    -w WARN         Warning threshold; default 300.
    --help          Print help and exit.
    --version       Print version and exit.
  Options must be given as --option value, not --option=value or -Ovalue.
  Use perldoc to read embedded documentation with more details.

=head1 DESCRIPTION

This Nagios plugin examines whether MySQL replication is delayed too much.  By
default it uses SHOW SLAVE STATUS, but the output of the Seconds_behind_master
column from this command is unreliable, so it is better to use pt-heartbeat from
Percona Toolkit instead.  Use the -T option to specify which table pt-heartbeat
updates.  Use the -s option to specify the master's server_id to compare
against; otherwise the plugin reports the maximum delay from any server. This
plugin does not support the legacy mk-heartbeat table format without the
server_id column.

=head1 PRIVILEGES

This plugin executes the following commands against MySQL:

=over

=item *

C<SHOW SLAVE STATUS>.

=item *

C<SELECT> from the C<pt-heartbeat> table.

=back

This plugin executes no UNIX commands that may need special privileges. 

=head1 COPYRIGHT, LICENSE, AND WARRANTY

This program is copyright 2012 Baron Schwartz, 2012 Percona Inc.
Feedback and improvements are welcome.

THIS PROGRAM IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, version 2.  You should have received a copy of the GNU General
Public License along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA.

=head1 VERSION

Percona Monitoring Plugins pmp-check-mysql-replication-delay 0.9.0

=cut

DOCUMENTATION

