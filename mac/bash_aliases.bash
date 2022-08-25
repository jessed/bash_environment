## All alias entries should be in here.

## Common / all platform aliases
alias ls='ls -GP'
alias ll='ls -Gl'
alias l1='ls -G1'
alias lh='ls -Glh'
alias la='ls -GlA'
alias ld='ls -Gld'
alias mv='mv -i'                      # Because I'm becoming a coward...
alias cp='cp -i'                      # Because I'm still a coward
alias s='sudo -E '                    # convenience alias, the space at the end is significant
alias svim='sudo vim '
alias vir='vim -R'                    # convenience alias
alias top='top -o cpu -O rsize -n30'  # make top provide something useful
alias duh='du -hd1'
alias ping='ping -n'
alias grep='grep --color=auto'
alias conns='netstat -anf inet'
alias my_ip='curl http://icanhazip.com'           # get public IP
alias clear_ssh='unset SSH_AUTH_SOCK'

## misc utilities
alias synergyc='sudo nice -n -15 /usr/bin/synergyc -n macrobeast blkbeast'
alias synergys='sudo nice -15 /usr/bin/synergys -c ~/local/synergys.conf'
alias lock='xlock -mode blank'
alias syncdir='rsync -auzv --exclude="*.swp"'
alias traceroute='traceroute -nw 1'
alias stat='stat -x'
alias htop='sudo htop'

## screen aliases
alias lscr='screen -xRRS standard -p1'             # local screen session
alias rs='screen -c ~/.screen/remote -xRRS remote' # remote screen session
alias perf='screen -c ~/.screen/perf -xRRS perf'   # performance screen session


# Source ltm_functions
test -e ~/f5_env/ltm_functions.bash     && source ~/f5_env/ltm_functions.bash

## Pull in additional bash alias and function files
SOURCES=""
SOURCES="$SOURCES .docker_aliases.bash .k8s_aliases.bash .terraform_aliases.bash"
SOURCES="$SOURCES .vmware_functions.bash"

for s in $SOURCES; do test -e ${HOME}/${s} && source ${HOME}/${s}; done


# SSH host aliases 
# All SSH host alias files should be in ~/.local/ and end with '_hosts.bash'
host_aliases=$(ls -1 ~/local/*_hosts.bash)
for f in $host_aliases; do test -f $f -o -L $f && source $f; done

