#!/bin/ksh

############################################################
#
# "What's up" system monitoring script for identifying bottlenecks.
#
# Written by David Personette
#
############################################################

############################################################
# The following parameters can be modified before running:
############################################################

#set -x

# Delay (in seconds) between monitoring sweeps.
# NOTE: frequent scans can cause performance issues (values below 120 are
#       not recomended)
DELAY=300       # by default run every 5 minutes

# Logging directory
LOG_DIR=/var/tmp/collector

# Format the output of the date command
DATEFMT='+%Y%m%d-%H:%M:%S'

# Set a LOCALE that is readable
if [ -z "$(echo ${LANG} | grep -E '^(en_|C)$')" ]; then
    export LANG=C
    export LC_TIME=C
fi

############################################################
# Don't modify anything below this point
############################################################

echo "All logs are generated in the ${LOG_DIR} by default."
echo ""
echo "When sending logs, please include a detailed description of the expected"
echo "and observed behaviour and the SPECIFIC time(s) of events in a text file."
echo ""
echo "Please do not modify the files generated by this script."
echo ""

HOSTNAME=$(uname -n)
OS=$(uname -s)

case ${OS} in
    HP-UX|SunOS)
        export PATH=/bin:/usr/bin:/usr/sbin:/sbin:/usr/ucb:/usr/local/bin
        export PATH=${PATH}:/usr/platform/$(uname -m)/sbin
        ;;
    Linux)
        export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
        export PATH=${PATH}:/usr/bin/X11:/usr/X11R6/bin:/root/bin
        ;;
    *)
        echo "${OS} is an unsupported OS!"
        echo "Works with Solaris (2.6/7/8/9), HP-UX (10/11/11i), and Linux."
        exit 1
        ;;
esac

[ -d ${LOG_DIR} ] || mkdir -p ${LOG_DIR}

############################################################
# Add seperator to log
############################################################
logit () {
    echo '-----------------------------'" (${1})" \
          '-------------------------------' >>${LOG}
    echo "$(eval ${1} 2>&1)" >>${LOG}
}

############################################################
# Common static info
############################################################
static () {
    LOG=${LOG_DIR}/${HOSTNAME}-static.log

    logit "date ${DATEFMT}"
    logit "uname -a"
    logit "uptime"
    logit "dmesg"
    logit "netstat -rn"
    logit "ipcs -a"

    case ${OS} in
        HP-UX) hpux_static ;;
        SunOS) solaris_static ;;
        Linux) linux_static ;;
    esac
}

############################################################
# HP-UX static info
############################################################
hpux_static () {
    logit "bdf"
    logit "sysdef"
    logit "swlist"
    logit "lanscan -v"

    echo '-----------------------------'" (ndd)" \
          '-------------------------------' >>${LOG}
    ndd /dev/tcp \? | grep -Ev "write only|obsoleted|\?" | awk '{print $1}' |
          while read line; do
        echo "${line}     \c" >>${LOG}
        ndd  /dev/tcp ${line} >>${LOG}
    done
}

############################################################
# Solaris static info
############################################################
solaris_static () {
    logit "df -k"
    logit "cat /etc/system"
    logit "ulimit -a"
    logit "prtdiag"
    [ -n "$(which isainfo 2>&1 | grep /isainfo)" ] && logit "isainfo -vb"
    [ -n "$(which sysdef 2>&1 | grep /sysdef)" ] && logit "sysdef"
    [ -n "$(which psrinfo 2>&1 | grep /psrinfo)" ] && logit "psrinfo"
    logit "pkginfo -l"
    logit "showrev -p"
    logit "ifconfig -a"

    echo '-----------------------------'" (ndd)" \
          '-------------------------------' >>${LOG}
    ndd /dev/tcp \? | grep -Ev "write only|obsoleted|\?" | awk '{print $1}' |
          while read line; do
        echo "${line}     \c" >>${LOG}
        ndd  /dev/tcp ${line} >>${LOG}
    done
}

############################################################
# Linux static info
############################################################
linux_static () {
    logit "df -h"
    logit "sysctl -a"
    logit "ulimit -a"
    logit "cat /proc/cpuinfo"
    logit "rpm -qa"
    logit "dpkg -l"
    logit "ipcs -a"
    logit "ifconfig -a"
}

############################################################
# common dynamic info
############################################################
dynamic () {
    LOG=${LOG_DIR}/${HOSTNAME}-files.log
    date ${DATEFMT} >>${LOG}
    [ -n "$(which lsof 2>&1 | grep /lsof)" ] && logit "nice lsof -i"

    LOG=${LOG_DIR}/${HOSTNAME}-net.log
    date ${DATEFMT} >>${LOG}
    logit "netstat -an"
    logit "netstat -s"

    LOG=${LOG_DIR}/${HOSTNAME}-procs.log
    date ${DATEFMT} >>${LOG}
    logit "ipcs -a"

    LOG=${LOG_DIR}/${HOSTNAME}-vm.log
    date ${DATEFMT} >>${LOG}
    logit "vmstat 15 2"

    case ${OS} in
        HP-UX) hpux_dynamic ;;
        SunOS) solaris_dynamic ;;
        Linux) linux_dynamic ;;
    esac
}

############################################################
# HP-UX dynamic info
############################################################
hpux_dynamic () {
    LOG=${LOG_DIR}/${HOSTNAME}-files.log
    logit "bdf"

    LOG=${LOG_DIR}/${HOSTNAME}-procs.log
    logit "ps -elf"
    logit "top -d 1"
}

############################################################
# Solaris dynamic info
############################################################
solaris_dynamic () {
    LOG=${LOG_DIR}/${HOSTNAME}-files.log
    logit "df -k"

    LOG=${LOG_DIR}/${HOSTNAME}-procs.log
    unset UNIX95
    [ -x /usr/ucb/ps ] && logit "/usr/ucb/ps auxwww" ||
          logit "ps -efl"
    # sort the running processes by size
    logit "ps -eo pid,vsz,rss,pmem,pcpu,args | sort +1n"
    # prstat is kind of like top
    logit "prstat -a 10 1"
}

############################################################
# Linux dynamic info
############################################################
linux_dynamic () {
    LOG=${LOG_DIR}/${HOSTNAME}-files.log
    logit "df -h"

    LOG=${LOG_DIR}/${HOSTNAME}-procs.log
    logit "ps auxwww"
    logit "top -b -n 1"
}

############################################################
# run static functions to collect static info (once):
############################################################

static

############################################################
# run dynamic functions to collect dynamic info (periodically):
############################################################
while true; do
    dynamic
    sleep ${DELAY}
done