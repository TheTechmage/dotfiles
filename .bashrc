
# Check for an interactive session
[ -z "$PS1" ] && return

. ~/fb/autocomplete.sh

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias java='/opt/java/jre/bin/java'
alias srls='sr -elvi|less'
PATH=$PATH:~/bin:~/fbin:/usr/lib/surfraw
PS1='\[\e[1;34m\]Frostyfrog\[\e[0;31m\]\w\[\e[0;32m\]\$\[\e[0m\] '
export EDITOR="vim"
export pi=$(echo "scale=10; 4*a(1)" | bc -l)

calc() {
	echo "$*" | bc -l;
}
if [ -f .alias ]; then
	. .alias
fi

complete -cf sudo

#export PS1=$'┌%{\e[44;30m%} %n %{\e[m%}%{\e[45;30m%} %m %{\e[m%}%{\e[40;1;33m%} %~ %{\e[0m%}|
#└%{\e[41;30m%} %% %{\e[0m%}¬ '

#PS1='C:\W>'
