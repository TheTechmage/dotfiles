
# Check for an interactive session
[ -z "$PS1" ] && return

if [ -f $HOME/fb/autocomplete.sh ]; then
	. $HOME/fb/autocomplete.sh
fi

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
#alias java='/opt/java/jre/bin/java'
alias srls='sr -elvi|less'
export GOPATH=$HOME/go:$HOME/projects/go/
export TMPDIR=/tmp
export PATH=$PATH:$HOME/bin:$HOME/fbin:/usr/lib/surfraw:$HOME/.gem/ruby/2.0.0/bin:$HOME/go/bin
PS1='\[\e[1;34m\]\u\[\e[0;31m\]\w\[\e[0;32m\]\$\[\e[0m\] '
export EDITOR="vim"
export pi=$(echo "scale=10; 4*a(1)" | bc -l)
export HISTFILESIZE= HISTSIZE= HISTFILE=~/.bash4_history
export HISTCONTROL=erasedups

calc() {
	echo "$*" | bc -l;
}
if [ -f $HOME/.alias ]; then
	. $HOME/.alias
fi

complete -cf sudo

#export PS1=$'┌%{\e[44;30m%} %n %{\e[m%}%{\e[45;30m%} %m %{\e[m%}%{\e[40;1;33m%} %~ %{\e[0m%}|
#└%{\e[41;30m%} %% %{\e[0m%}¬ '

#PS1='C:\W>'

# If you get distorted sound in skype, try adding PULSE_LATENCY_MSEC=60 to your
# env before starting skype. Something like 'export PULSE_LATENCY_MSEC=60' in .bashrc, for example.
if [[ "$(hostname)" == "Ogre" ]]; then
	export DOCKER_HOST=tcp://172.24.0.13:2375
fi
