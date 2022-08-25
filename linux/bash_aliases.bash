## All alias entries should be in here.
alias ls='ls --color=always'
alias ll='ls -l --color=always'
alias l1='ls -1 --color=always'
alias lh='ls -lh --color=always'
alias la='ls -lA --color=always'
alias ld='ls -ld --color=always'

#alias vi='vim'                                      # convenience alias, need to deprecate
alias mv='mv -i'                                    # Because I'm becoming a coward...
alias cp='cp -i'                                    # Because I'm still a coward
alias s='sudo -E'                                   # convenience alias
alias duh='du -hd 1'
alias last='last | head -20'
alias grep='grep -v grep | grep -i --color=auto -E'
alias lock='xlock -mode blank'
alias syncdir='rsync -auzv --exclude="*.swp"'
alias lscr='screen -xRRS standard -p1'              # local screen session
alias rs='screen -c ~/.screen/remote -xRRS remote'  # remote screen session
alias perf='screen -c ~/.screen/perf -xRRS perf'    # performance screen session
alias stat='stat -x'
#alias whois='whois -H'
alias tail='tail -n20'          # specifying the number of lines a second time fails on mac
alias my_ip='curl http://icanhazip.com'

alias ping='ping -n'
alias traceroute='traceroute -nw 1'
alias conns='netstat -an4'

alias sctl='sudo systemctl'


## Pull in additional bash alias and function files
SOURCES=""
SOURCES="$SOURCES .apt_aliases.bash .centos_aliases.bash"
SOURCES="$SOURCES .virt_aliases.bash .docker_aliases.bash .k8s_aliases.bash .terraform_aliases.bash"

for s in $SOURCES; do test -e ${HOME}/${s} && source ${HOME}/${s}; done

# Source ltm_functions
test -e ~/f5_env/ltm_functions.bash     && source ~/f5_env/ltm_functions.bash

# SSH host aliases
# All SSH host alias files should be in ~/.local/ and end with '_hosts.bash'
host_aliases=$(ls -1 ~/local/*_hosts.bash)
for f in $host_aliases; do test -f $f -o -L $f && source $f; done
