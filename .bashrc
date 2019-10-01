# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

export GOPATH="$HOME/dev/go"
export PATH="$HOME/.local/bin:$HOME/.pyenv/bin:$HOME/.rbenv/bin:$GOPATH/bin:$HOME/.yarn/bin:$HOME/.cargo/bin:/usr/lib/ccache:/usr/local/go/bin:$HOME/bin:$PATH:/opt/rocm/bin:/opt/rocm/profiler/bin:/opt/rocm/opencl/bin/x86_64:$HOME/dev/mx:/usr/local/cuda/bin:/snap/bin"
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

which rbenv 2> /dev/null > /dev/null && eval "$(rbenv init -)"

if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    export DOCKER_HOST=tcp://localhost:2375
    if [ "$SSH_CLIENT" != "" ] ; then
        true
        # ulimit -s unlimited # workaround for WSL ruby
    fi
fi

# Python
alias py='PYTHONSTARTUP=~/.pythonrc.py python3'
if which pyenv 2> /dev/null > /dev/null ; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    alias py='PYTHONSTARTUP=~/.pythonrc.py python'
fi

if [ -f ~/.bazel/bin/bazel-complete.bash ] ; then
    source ~/.bazel/bin/bazel-complete.bash
fi

# cuDNN
export LD_LIBRARY_PATH="$HOME/.cudnn/active/cuda/lib64:$LD_LIBRARY_PATH"
export CPATH="$HOME/.cudnn/active/cuda/include:$CPATH"
export LIBRARY_PATH="$HOME/.cudnn/active/cuda/lib64:$LIBRARY_PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/twata/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/twata/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/twata/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/twata/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

if which direnv 2>/dev/null >/dev/null; then
    eval "$(direnv hook bash)"

    show_virtual_env() {
        if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
            echo "($(basename $VIRTUAL_ENV))"
        fi
    }
    export -f show_virtual_env
    PS1='$(show_virtual_env)'$PS1
fi

alias be='bundle exec'
alias dc='docker-compose'
alias d='docker'
alias k='kubectl'
alias g='git'
alias emacs='emacs -nw'
alias remacs='remacs -nw'

alias_completion(){
    # keep global namespace clean
    local cmd completion

    # determine first word of alias definition
    # NOTE: This is really dirty. Is it possible to use
    #       readline's shell-expand-line or alias-expand-line?
    cmd=$(alias "$1" | sed 's/^alias .*='\''//;s/\( .\+\|'\''\)//')

    # determine completion function
    completion=$(complete -p "$1" 2>/dev/null)

    # run _completion_loader only if necessary
    [[ -n $completion ]] || {

        # load completion
        _completion_loader "$cmd"

        # detect completion
        completion=$(complete -p "$cmd" 2>/dev/null)
    }

    # ensure completion was detected
    [[ -n $completion ]] || return 1

    # configure completion
    eval "$(sed "s/$cmd\$/$1/" <<<"$completion")"
}

aliases=(be dc d g)
for a in "${aliases[@]}"; do
    if ! which "$a" 2>/dev/null >/dev/null ; then
        continue
    fi
    alias_completion "$a"
done
unset a aliases

export SNPE_ROOT="$HOME/dev/snpe/snpe-1.30.0.480"
export LD_LIBRARY_PATH="$SNPE_ROOT/lib/x86_64-linux-clang:$LD_LIBRARY_PATH"

if which kubectl >/dev/null 2>/dev/null ; then
    source <(kubectl completion bash)
fi
