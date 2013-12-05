#!/bin/sh
#
# rbldns: an init script to start & stop the rbldns service daemon.
#
# chkconfig: - 20 80
# description: rbldns is a Real time Block List DNS server.
#

### BEGIN INIT INFO
# Provides:          rbldns
# Required-Start:    $network
# Required-Stop:     $network
# Default-Stop:      0 1 2 3 4 5 6
# Short-Description: start and stop rbldns daemon at boot time.
# Description:       rbldns is a Real time Block List DNS server.
### END INIT INFO

# Source function library.
. /etc/init.d/functions

# Source networking configuration
. /etc/sysconfig/network

prog=rbldns
exec=PREFIX/sbin/rbldns
config=/etc/ndjbdns/rbldns.conf
logfile=/var/log/rbldns.log
lockfile=/var/lock/subsys/rbldns

[ -e /etc/sysconfig/$prog ] && . /etc/sysconfig/$prog

start() {
    [ -x $prog ] || exit 5
    [ -f $config ] || exit 6
    echo -n $"Starting ${prog}: "
    daemon $exec -D 2>> $logfile
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch $lockfile
    return $RETVAL
}

stop() {
    echo -n $"Stopping ${prog}: "
    killproc $exec
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && rm -f $lockfile
    return $RETVAL
}

restart() {
    stop
    start
}

reload() {
    restart
}

force_reload() {
    restart
}

rh_status() {
    status $prog
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}


case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
        exit 2
esac
exit $?
