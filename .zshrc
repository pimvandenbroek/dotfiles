#load shell dotfiles
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# .zshrc
autoload -U promptinit; promptinit
prompt spaceship

#spaceship
SPACESHIP_USER_SHOW=true
SPACESHIP_TIME_SHOW=always
SPACESHIP_HOST_SHOW=false
SPACESHIP_TIME_COLOR=#22DA6E
SPACESHIP_PROMPT_ORDER=(
    time
    user
    dir
    exit_code
    char
    git
)
SPACESHIP_DIR_TRUNC=4
#autocomplete
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
  rm -f "$SSH_AUTH_SOCK"
  wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
  if test -x "$wsl2_ssh_pageant_bin"; then
    (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &)
  else
    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
  fi
  unset wsl2_ssh_pageant_bin
fi
