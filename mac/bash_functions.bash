# ~/.bash_functions
# My function list is getting too involved for .bash_aliases

# start the ssh-agent using whatever $SSH_AUTH_SOCK is defined
startagent() {
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    echo "ERROR: \$SSH_AUTH_SOCK not defined"
    return
  else
      #KEYS="id_rsa cpt_shared.key github_rsa2"
      #KEYS="$KEYS jessed_secure.key git_itc.key"
      KEYS="id_rsa cpt_shared.key github_rsa2 cloud_f5.pem aws_f5.pem"
    eval $(ssh-agent -a $SSH_AUTH_SOCK)
    if [ -n "$1" ]; then
      ssh-add $1
    else
      for k in $KEYS; do
        test -f ~/.ssh/${k} && ssh-add ~/.ssh/${k} || echo "key ~/.ssh/$k not found"
      done
      echo $SSH_AGENT_PID > ${TMPDIR}/ssh_agent_pid
    fi
  fi
}

# Update ssh environment info
update_ssh_env () {
  # If $SSH_AUTH_SOCK doesn't exist, clean up manual pid file
  if [[ ! -S ${SSH_AUTH_SOCK} && -n ${SSH_AGENT_PID+x} ]]; then
    rm ${TMPDIR}/ssh_agent_pid 2>/dev/null
    unset SSH_AGENT_PID
  elif [[ -z ${SSH_AGENT_PID+x} ]]; then
    # Add SSH_AGENT_PID environment var if not present
    test -f ${TMPDIR}ssh_agent_pid && export SSH_AGENT_PID=$(<${TMPDIR}ssh_agent_pid)
  fi
}

# check the hosts file for the string
# similar to 'host' but for the hosts file
hosts() {
  if [[ -z "$1" ]]; then echo -e "\tUSAGE:  $0 <hostname>"
  else myhost=$1
  fi

  grep -E $myhost /etc/hosts

  if [[ $? -ne 0 ]]; then
    echo "$myhost not found in /etc/hosts, checking with 'host'"
    host $myhost
  fi
}

watchhost() {
  go=1
  while [ $go -eq 1 ]; do
    ping -c1 -W 1 $1 >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      #echo "ping succeeded, sleeping"
      sleep 1
    else
      #echo "ping failed, setting go = 0"
      echo "No echo response, entering notification phase"
      go=0
      sleep 1
    fi
  done

  while [ 1 ]; do
    ping -c1 $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      sleep 1
    else
      echo -e "$1 is up\a"
      sleep 1
    fi
  done
}

# List all interfaces with addresses along with the address and mac
unset -f addr
addr() {
  nics=$(ifconfig -a | awk '/^[a-z]/ { gsub(":[[:space:]]"," "); print $1}' | sort -n)
  match="(lo|gif|stf|pop|awdl|utun|fw|vnic)"

  for n in $nics; do
    if [[ $n =~ $match ]]; then continue
    else iface=$n
    fi
    if [[ -f /etc/issue ]]; then # linux
      info=$(ip addr show $iface)
      mac=$(echo "$info" | awk '/ether /{ print $2 }')
      addr=$(echo "$info" | awk '/inet / { print $2 }')
    else # mac
      info=$(ifconfig $iface)
      mac=$(echo "$info" | awk '/ether / { print $2}')
      addr=$(echo "$info" | awk '/inet / { print $2}')
    fi
    if [[ -n "$addr" ]]; then
      printf "%-15s %15s (%s)\n" $n $addr $mac
    fi
    unset -v iface info addr mac
  done
}

# List all interfaces with addresses along with the address and mac
unset -f addr2
addr2() {
  match="(lo|gif|stf|pop|awdl|bridge|utun|fw|vnic)"

  #nics=$(ip link show | awk '/^[[:digit:]]/ {gsub(":"," "); print $2}')
  nics=$(ifconfig -a | awk '/^[a-z]/ { gsub(":[[:space:]]"," "); print $1}')

  for n in $nics; do
    declare -a addr
    if [[ $n =~ $match ]]; then continue
    else iface=$n
    fi

    if [[ -f /etc/issue ]]; then
      # linux
      mac=$(ip addr show $iface | awk '/ether/{ print $2 }')
      addr+=($(ip addr show $iface | awk '/inet /{ print $2 }'))
    else
      # mac
      info=$(ifconfig $iface)
      mac=$(echo "$info" | awk '/ether / { print $2}')
      addr+=$(echo "$info" | awk '/inet / { print $2}')
    fi

    # Only print the interface name if the first address is populated
    if [[ -n "${addr[0]}" ]]; then
      s="${iface}"
      iPad=$(expr 10 - $(echo -n "${s}" | wc -c))
      printf "%-${iPad}s" ${s}
    fi
    # calculate the length of padding to use for the first address output
    # I want a consistent column depth while still having the first address on the same line
    # as the interface id
    aPad=20
    for a in ${addr[@]} ; do
      mPad=$(expr 25 - $(echo -n ${a} | wc -c))
      m="(${mac})"
      printf "%${iPad}s %-${aPad}s %-${mPad}s\n" " " $a $m
      iPad=10
    done
    unset -v iface info addr mac
  done
}

# redefine 'exit' to be screen-friendly (new method, compatible with OS X)
exit() {
  if [[ -n "$WINDOW" ]]; then
    screen -p $WINDOW -X pow_detach
  else
    kill -1 $$
  fi
}

# count the characters in the string
count() {
  if [ -z "$1" ]; then echo "Must provide a string"; return; fi

  string=$1
  echo -n "$string" | wc -c
}

reminder() {
  if [ -z "$1" ]; then
    timer=180
  else
    if [ $1 -lt 60 ]; then
      timer=$((1*60))
    else
      timer=$1
    fi
  fi

  echo "Reminder will occur in $timer seconds"
  sleep $timer

  while [ 1 ]; do
    echo -e "\a"
    sleep 1
  done
}

clrlog() {
  if [[ -z "$1" ]]; then
    echo "USAGE: $0 <log file>"; exit 1
  else
    file=$1
  fi

  rm $file
  sudo service syslog-ng restart
}

# Open pcap in new Wireshark instance
wsopen() {
  /Applications/Wireshark.app/Contents/MacOS/Wireshark "$@" >/dev/null 2>&1 &
}

unset -f update_hosts
update_hosts() {
  if [[ -z $1 || -z $2 ]]; then
    echo "USAGE $0 <hostname> <ip>"
    return
  else
    host=$1
    ip=$2
  fi

  old_ip=$(awk -v host=$host '$0 ~ host {print $1}' /etc/hosts)
  #echo "Found $old_ip, replacing with $ip"
  echo sudo -E -- sed -i '' s/$old_ip/$ip/ /etc/hosts
  sudo -E -- sed -i '' s/$old_ip/$ip/ /etc/hosts
}

##
## OS X only
##
listdomains() {
  defaults domains | sed y/" "/"\n"/ | sed s/' '//
}

# vim: set syntax=bash:
