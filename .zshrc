#load shell dotfiles
for file in ~/.{path,bash_prompt,exports,bash_aliases,functions,extra}; do
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

#autocomplete
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

#aliases
source $HOME/.aliases

eval "$(starship init zsh)"
