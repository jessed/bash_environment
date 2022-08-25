# ~/.bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

test -f /etc/bashrc       && . /etc/bashrc        # system-wide bashrc
test -f ~/.bash_aliases   && . ~/.bash_aliases    # bash aliases
test -f ~/.bash_functions && . ~/.bash_functions  # bash utility functions

# Add to what is defined in /etc/environment
if [ ! $PATHSRCD ]; then
  PATH="$HOME/local/bin:$PATH:/sbin:/usr/sbin:/usr/local/sbin"

  # Terraform extensions
  PATH="$PATH:$HOME/.krew/bin"

  export PATHSRCD=1
fi

# create ~/.HISTORY if it doesn't already exist
test -d $HOME/HISTORY || mkdir $HOME/.HISTORY

# bash history variables/settings
export HISTCONTROL=ignoredups
export HISTFILE="$HOME/.HISTORY/$(date +%Y-%m).bash_history"
export HISTTIMEFORMAT="%F %T  "
export HISTFILESIZE=300000
export HISTSIZE=300000
export HISTIGNORE="&:ls:[bf]g:exit"

## Environment variables
export EDITOR=vim
export VISUAL=vim
export FCEDIT=vim
export KUBE_EDITOR=vim
export HOSTFILE="/etc/hosts"

# export ssh-agent file
export SSH_AUTH_SOCK=$HOME/.ssh/screen-ssh-agent

# clean up ssh environment if the ssh sock file doesn't exist
# this function is located in ~/.bash_functions
update_ssh_env


# Bash options
shopt -s checkwinsize # update the values of LINES and COLUMNS.
shopt -s histappend   # Append to the history file, do not overwite
shopt -s cmdhist      # save multi-line commands
shopt -s hostcomplete # attempt to perform hostname completion following a '@' sign

# Use VI mode
set -o vi
#stty eof ^p
#bind -m vi-move "Control-d:\"iexit\n\""
#bind -m vi-insert "Control-d:\"exit\n\""

# enable color support
if [ "$TERM" != "dumb" ]; then
  test -f ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Define color variables for the 'ls' command
export CLICOLOR
export CLICOLOR_FORCE
export LSCOLORS=ExGxfxBxCxDxDxhbHbacad

## custom prompt variables
PROMPT_DIRTRIM=4
SCRN='\[\ek$(echo -n M${WINDOW})\e\\\]'
TITLE='\[\e]0;\u@\h\a'
BLINK="\[\e[5m\]"
CLR="\[\e[0m\]"
GREEN="\[\e[0;32m\]"
RED="\[\e[0;31m\]"
BLUE="\[\e[0;34m\]"
CYAN="\[\e[0;36m\]"
PURPLE="\[\e[0;35m\]"
BROWN="\[\e[0;33m\]"
LTBLUE="\[\e[1;34m\]"
LTGREEN="\[\e[1;32m\]"
LTRED="\[\e[1;31m\]"
LTCYAN="\[\e[1;36m\]"
YELLOW="\[\e[1;33m\]"
WHITE="\[\e[1;37m\]"

#custom prompt
mk_prompt () {
  if [ `id -u` -eq '0' ]; then
    COLOR=${RED}; #COLOR=${RED}${BLINK}
  else
    COLOR=${GREEN}
  fi

  if [[ -n "$WINDOW" ]]; then
    PS1="${COLOR}${SCRN}\h:\w >${CLR}"
  else
    #PS1="${COLOR}\h:\w >${CLR}"    # My standard prompt
    PS1="${RED}[${CYAN}\A${RED}]${CLR}\n${COLOR}\h:\w >${CLR}"
    PS1="${TITLE}$PS1"
  fi

  # Update the Go env variables
  # TODO: This should be changed to use direnv, not a bash function
  update_go
}
export PROMPT_COMMAND="history -a; mk_prompt"


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# Keep this as the final action in .bashrc
test -f ~/.bash_local     && . ~/.bash_local      # programming language environment

