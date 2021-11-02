#!/bin/bash
sudo apt update
#zsh
sudo apt install zsh
chsh -s $(which zsh)

#spaceship
git clone https://github.com/spaceship-prompt/spaceship-prompt.git --depth=1
mkdir .zfunctions
cd spaceship-prompt
sudo ln -sf "$PWD/spaceship.zsh" "/usr/local/share/zsh/site-functions/prompt_spaceship_setup"
fpath=( "${ZDOTDIR:-$HOME}/.zfunctions" $fpath )
cd spaceship-prompt
sudo ln -sf "$PWD/spaceship.zsh" "${ZDOTDIR:-$HOME}/.zfunctions/prompt_spaceship_setup"

#zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

#back to home
cd

#wsl2-ssh-pageant
destination="$HOME/.ssh/wsl2-ssh-pageant.exe"
wget -O "$destination" "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-s># Set the executable bit.
chmod +x "$destination"

#reload shell
exec ${SHELL} -l
