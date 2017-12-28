# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2013 Yad Smood

# VCS
FROSTY_VCS_PROMPT_PREFIX1=" %{$fg[white]%}on%{$reset_color%} "
FROSTY_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
FROSTY_VCS_PROMPT_SUFFIX="%{$reset_color%}"
FROSTY_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
FROSTY_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"
FROSTY_VCS_PROMPT_PENDING=" %{$fg[yellow]%}?"

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${FROSTY_VCS_PROMPT_PREFIX1}git${FROSTY_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FROSTY_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$FROSTY_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$FROSTY_VCS_PROMPT_CLEAN"

# HG info
local hg_info='$(frosty_hg_prompt_info)'
frosty_hg_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.hg' ]; then
		echo -n "${FROSTY_VCS_PROMPT_PREFIX1}hg${FROSTY_VCS_PROMPT_PREFIX2}"
		echo -n $(hg branch 2>/dev/null)
		if [ -n "$(hg status 2>/dev/null)" ]; then
			echo -n "$FROSTY_VCS_PROMPT_DIRTY"
		else
			echo -n "$FROSTY_VCS_PROMPT_CLEAN"
		fi
		echo -n "$FROSTY_VCS_PROMPT_SUFFIX"
	fi
}

# GIT info
local bzr_info='$(frosty_bzr_prompt_info)'
frosty_bzr_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.bzr' ]; then
		echo -n "${FROSTY_VCS_PROMPT_PREFIX1}bzr${FROSTY_VCS_PROMPT_PREFIX2}"
		echo -n $(bzr revno 2>/dev/null)
		if [ -n "$(bzr status -V 2>/dev/null)" ]; then
			echo -n "$FROSTY_VCS_PROMPT_DIRTY"
		elif [ -n "$(bzr status 2>/dev/null)" ]; then
			echo -n "$FROSTY_VCS_PROMPT_PENDING"
		else
			echo -n "$FROSTY_VCS_PROMPT_CLEAN"
		fi
		echo -n "$FROSTY_VCS_PROMPT_SUFFIX"
	fi
}

local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

# Prompt format:
#
# PRIVILEGES USER @ MACHINE in DIRECTORY on git:BRANCH STATE [TIME] C:LAST_EXIT_CODE
# $ COMMAND
#
# For example:
#
# % frosty @ frosty-mbp in ~/.oh-my-zsh on git:master x [21:47:42] C:0
# $
PROMPT="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$fg[white]%}@ \
%{$fg[green]%}%m \
%{$fg[white]%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${bzr_info}\
${hg_info}\
${git_info}\
 \
%{$fg[white]%}[%*] $exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
