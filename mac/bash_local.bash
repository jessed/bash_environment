# ~/.bash_local.bash

# direnv integration
if [[ -n $(which direnv) ]]; then
  eval "$(direnv hook bash)"
  export DIRENV_LOG_FORMAT=   # suppress direnv status messages
fi

# JAVA variables
export JAVA_HOME=$(/usr/libexec/java_home)


# Google Cloud
# The next line updates PATH for the Google Cloud SDK.
test -f /Users/driskill/google-cloud-sdk/path.bash.inc && . /Users/driskill/google-cloud-sdk/path.bash.inc
#if [ -f '/Users/driskill/google-cloud-sdk/path.bash.inc' ]; then . '/Users/driskill/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
test -f /Users/driskill/google-cloud-sdk/completion.bash.inc && . /Users/driskill/google-cloud-sdk/completion.bash.inc
#if [ -f '/Users/driskill/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/driskill/google-cloud-sdk/completion.bash.inc'; fi


## Additional completion settings
complete -C /usr/local/bin/terraform terraform

# Enable command completion for kubectl alias
complete -o default -F __start_kubectl k

#### DEPRECATED
# iTerm2 shell integration
#test -f ~/.iterm2_shell_integration.bash && source ~/.iterm2_shell_integration.bash
