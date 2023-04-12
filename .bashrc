# Sample .bashrc for SUSE Linux
# Copyright (c) SUSE Software Solutions Germany GmbH

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# add date and time formatting to bash history.
HISTTIMEFORMAT="%F %T "

# ignore duplicate commands in the history.
HISTCONTROL=ignoredups

# set the number of lines in active history
HISTSIZE=2000
HISTFILESIZE=2000

test -s ~/.alias && . ~/.alias || true
. "$HOME/.cargo/env"

eval "$(oh-my-posh init bash)"
eval "$(oh-my-posh init bash --config ~/.poshthemes/kushal.omp.json)"

# git
alias gcl='git clone --depth 1'
alias gin='git init'
alias gad='git add'
alias gcm='git commit -m'
alias gp='git push origin'
alias gch='git checkout'
alias gst='git status'

# ls
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

#scripts
alias gsc='~/dev-environment-files/./GitScript.sh'
alias tsi='~/dev-environment-files/./TaskInit.sh'
alias pychk='~/dev-environment-files/./run_pycodestyle.sh'
alias pychk-all='~/dev-environment-files/./run_pycodestyle_all.sh'

# Move to the parent folder.
alias ..='cd ..;pwd'
# Move up two parent folders.
alias ...='cd ../..;pwd'
# Move up three parent folders.
alias ....='cd ../../..;pwd'


# Press x to clear the terminal screen.
alias x='clear'
# Press h to view the bash history.
alias h='history'
# Display the directory structure better.
alias tree='tree --dirsfirst -F'
# Make a directory and all parent directories with verbosity.
alias mkdir='mkdir -p -v'
# Run valgrind with all the error checks flags on.
alias valg-full='valgrind -s --leak-check=full --show-leak-kinds=all --show-mismatched-frees=yes --track-origins=yes'

# helix
alias hx='helix'
