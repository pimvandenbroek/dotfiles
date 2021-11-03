#!/bin/bash

#----Check root privillege.
rootperm(){
  echo "Checking root"|date +"[%Y-%m-%d %H:%M:%S]"
  if [ "$(id -u)" -ne 0 ]; then
    error "You must be root"
	exit 1
  fi
}
rootperm

apt update -y > /dev/null 2>&1;
echo "Installing zsh"|date +"[%Y-%m-%d %H:%M:%S]"
#zsh
apt install zsh -y > /dev/null 2>&1;
chsh -s $(which zsh)

#spaceship
echo "Installing spaceship-prompt"|date +"[%Y-%m-%d %H:%M:%S]"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git --depth=1
mkdir .zfunctions
cd spaceship-prompt
ln -sf "$PWD/spaceship.zsh" "/usr/local/share/zsh/site-functions/prompt_spaceship_setup"
fpath=( "${ZDOTDIR:-$HOME}/.zfunctions" $fpath )
cd spaceship-prompt
ln -sf "$PWD/spaceship.zsh" "${ZDOTDIR:-$HOME}/.zfunctions/prompt_spaceship_setup"

echo "Installing autosuggestions"|date +"[%Y-%m-%d %H:%M:%S]"
#zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

#back to home
cd

if [ $2 = "wsl" ]; then 
  #wsl2-ssh-pageant
  destination="$HOME/.ssh/wsl2-ssh-pageant.exe"
  wget -O "$destination" "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe"
  # Set the executable bit.
  chmod +x "$destination"
fi

#reload shell
exec ${SHELL} -l
