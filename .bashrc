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

test -s ~/.alias && . ~/.alias || true

# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
	\builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
	# shellcheck disable=SC2164
	\builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
__zoxide_oldpwd="$(__zoxide_pwd)"

function __zoxide_hook() {
	\builtin local -r retval="$?"
	\builtin local pwd_tmp
	pwd_tmp="$(__zoxide_pwd)"
	if [[ ${__zoxide_oldpwd} != "${pwd_tmp}" ]]; then
		__zoxide_oldpwd="${pwd_tmp}"
		\command zoxide add -- "${__zoxide_oldpwd}"
	fi
	return "${retval}"
}

# Initialize hook.
if [[ ${PROMPT_COMMAND:=} != *'__zoxide_hook'* ]]; then
	PROMPT_COMMAND="__zoxide_hook;${PROMPT_COMMAND#;}"
fi

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

__zoxide_z_prefix='z#'

# Jump to a directory using only keywords.
function __zoxide_z() {
	# shellcheck disable=SC2199
	if [[ $# -eq 0 ]]; then
		__zoxide_cd ~
	elif [[ $# -eq 1 && $1 == '-' ]]; then
		__zoxide_cd "${OLDPWD}"
	elif [[ $# -eq 1 && -d $1 ]]; then
		__zoxide_cd "$1"
	elif [[ ${@: -1} == "${__zoxide_z_prefix}"* ]]; then
		# shellcheck disable=SC2124
		\builtin local result="${@: -1}"
		__zoxide_cd "${result:${#__zoxide_z_prefix}}"
	else
		\builtin local result
		# shellcheck disable=SC2312
		result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" &&
			__zoxide_cd "${result}"
	fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
	\builtin local result
	result="$(\command zoxide query -i -- "$@")" && __zoxide_cd "${result}"
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

\builtin unalias z &>/dev/null || \builtin true
function z() {
	__zoxide_z "$@"
}

\builtin unalias zi &>/dev/null || \builtin true
function zi() {
	__zoxide_zi "$@"
}

# Load completions.
# - Bash 4.4+ is required to use `@Q`.
# - Completions require line editing. Since Bash supports only two modes of
#   line editing (`vim` and `emacs`), we check if either them is enabled.
# - Completions don't work on `dumb` terminals.
if [[ ${BASH_VERSINFO[0]:-0} -eq 4 && ${BASH_VERSINFO[1]:-0} -ge 4 || ${BASH_VERSINFO[0]:-0} -ge 5 ]] &&
	[[ :"${SHELLOPTS}": =~ :(vi|emacs): && ${TERM} != 'dumb' ]]; then
	# Use `printf '\e[5n'` to redraw line after fzf closes.
	\builtin bind '"\e[0n": redraw-current-line' &>/dev/null

	function __zoxide_z_complete() {
		# Only show completions when the cursor is at the end of the line.
		[[ ${#COMP_WORDS[@]} -eq $((COMP_CWORD + 1)) ]] || return

		# If there is only one argument, use `cd` completions.
		if [[ ${#COMP_WORDS[@]} -eq 2 ]]; then
			\builtin mapfile -t COMPREPLY < <(
				\builtin compgen -A directory -- "${COMP_WORDS[-1]}" || \builtin true
			)
		# If there is a space after the last word, use interactive selection.
		elif [[ -z ${COMP_WORDS[-1]} ]]; then
			\builtin local result
			# shellcheck disable=SC2312
			result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -i -- "${COMP_WORDS[@]:1:${#COMP_WORDS[@]}-2}")" &&
				COMPREPLY=("${__zoxide_z_prefix}${result}/")
			\builtin printf '\e[5n'
		fi
	}

	\builtin complete -F __zoxide_z_complete -o filenames -- z
	\builtin complete -r zi &>/dev/null || \builtin true
fi

# =============================================================================
#
# To initialize zoxide, add this to your configuration (usually ~/.bashrc):
#
eval "$(zoxide init bash)"


### EXPORT
export TERM="xterm-256color"                      # getting proper colors
export HISTCONTROL=ignoredups:erasedups           # no duplicate entries
export ALTERNATE_EDITOR=""                        # setting for emacsclient

### SET MANPAGER
### Uncomment only one of these!

### "bat" as manpager
#export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias man='batman'

### "vim" as manpager
# export MANPAGER='/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'

### "nvim" as manpager
# export MANPAGER="nvim -c 'set ft=man' -"

### SET VI MODE ###
# Comment this line out to enable default emacs-like bindings
set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### PROMPT
# This is commented out if using starship prompt
# PS1='[\u@\h \W]\$ '

### PATH
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ;
  then PATH="$HOME/.cargo/bin:$PATH"
fi

### CHANGE TITLE OF TERMINALS
case ${TERM} in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|alacritty|st|konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
  screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

### SHOPT
shopt -s autocd # change to named directory
shopt -s cdspell # autocorrects cd misspellings
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s dotglob
shopt -s histappend # do not overwrite history
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize # checks term size when bash regains control

#ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

### COUNTDOWN

cdown () {
    N=$1
  while [[ $((--N)) >  0 ]]
    do
        echo "$N" |  figlet -c | lolcat &&  sleep 1
    done
}

### ARCHIVE EXTRACTION
# usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# add date and time formatting to bash history.
HISTTIMEFORMAT="%F %T "

# ignore duplicate commands in the history.
HISTCONTROL=ignoredups

# set the number of lines in active history
HISTSIZE=2000
HISTFILESIZE=2000

### ALIASES ###
# \x1b[2J   <- clears tty
# \x1b[1;1H <- goes to (1, 1) (start)
#alias clear='echo -en "\x1b[2J\x1b[1;1H" ; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo'
alias x='clear'
alias h='history' # Press h to view the bash history.

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# vim and helix
#alias vi='vim'
alias vim='nvim'
#alias hx='helix'
alias hxhe='hx --health'

# Changing "ls" to "lsd"
alias ls='lsd --group-directories-first --header'
alias l='lsd -lh --group-directories-first --header'
alias lla='lsd -lah --group-directories-first --header'
alias la='lsd -A --group-directories-first --header'
alias lr='lsd -R --group-directories-first --header'
alias lt='lsd -lth --group-directories-first --header'
alias l.='lsd -a | egrep "^\."'

# Changing "ls" to "exa"
# alias ls='exa -al --color=always --group-directories-first --header --icons' # my pref listing
# alias la='exa -a --color=always --group-directories-first --header --icons'  # all files and dirs
# alias ll='exa -l --color=always --group-directories-first --header --icons'  # long format
# alias lla='exa -al --color=always --group-directories-first --header --icons'  # all + long format
# alias lt='exa -aT --color=always --group-directories-first --header --icons' # tree listing
# alias l.='exa -a --icons | egrep "^\."'
# alias l='exa --icons'
# alias lg='exa --group --header --group-directories-first --long --git --git-ignore --icons'
# alias lo='exa --group --header --group-directories-first --oneline --icons'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# adding flags
alias df='df -h'                 # human-readable sizes
alias free='free -m'             # show sizes in MB
alias tree='tree --dirsfirst -F' # Display the directory structure better.
alias mkdir='mkdir -p -v'        # Display the directory structure better.
# Run valgrind with all the error checks flags on.
alias valg-full='valgrind -s --leak-check=full --show-leak-kinds=all --show-mismatched-frees=yes --track-origins=yes'

#scripts
alias gsc='~/dotfiles/./GitScript.sh'
alias tsi='~/dotfiles/./TaskInit_2.0.sh'
alias pychk='~/dotfiles/./run_pycodestyle.sh'
alias pychk-all='~/dotfiles/./run_pycodestyle_all.sh'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# git
alias gst='git status'
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# gpg encryption
# verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# youtube-dl
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "
alias ytv-best="youtube-dl -f bestvideo+bestaudio "

# switch between shells
# I do not recommend switching default SHELL from bash.
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
#alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

# bare git repo alias for dotfiles
#alias config="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"

# termbin
#alias tb="nc termbin.com 9999"

# the terminal rickroll
#alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

### RANDOM COLOR SCRIPT ###
# Get this script from my GitLab: gitlab.com/dwt1/shell-color-scripts
# Or install it from th
# e Arch User Repository: shell-color-scripts
colorscript random

# PROMPT
eval "$(oh-my-posh init bash)"
eval "$(oh-my-posh init bash --config ~/.poshthemes/emodipt-extend.omp.json)"
