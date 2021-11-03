#!/bin/bash

echo 'Setup for wsl or not (y/n):'
read wsl
apt update -y > /dev/null 2>&1;

#Check root privilege.
rootperm(){
    echo "Checking root"|date +"[%Y-%m-%d %H:%M:%S]"
    if [ "$(id -u)" -ne 0 ]; then
        error "You must be root"
	    exit 1
    fi
    if [ $SUDO_USER ]; then
        real_user=$SUDO_USER
        export real_path=$(sudo -i -u $SUDO_USER echo \$HOME)
    else
        real_user=$(whoami)
        export real_path=$HOME
    fi
}

#zsh
zsh() {
    echo "Installing zsh"|date +"[%Y-%m-%d %H:%M:%S]"
    #zsh
    apt install zsh -y > /dev/null 2>&1;
}

#spaceship
spaceship() {
    echo "Installing spaceship-prompt"|date +"[%Y-%m-%d %H:%M:%S]"
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git --depth=1
    mkdir .zfunctions
    cd $real_path/spaceship-prompt
    ln -sf "$PWD/spaceship.zsh" "/usr/local/share/zsh/site-functions/prompt_spaceship_setup"
    fpath=( "${ZDOTDIR:-$real_path}/.zfunctions" $fpath )
    ln -sf "$PWD/spaceship.zsh" "${ZDOTDIR:-$real_path}/.zfunctions/prompt_spaceship_setup"
}

#zsh-autosuggestions
autosuggestions(){
    echo "Installing autosuggestions"|date +"[%Y-%m-%d %H:%M:%S]"   
    git clone https://github.com/zsh-users/zsh-autosuggestions $real_path/.zsh/zsh-autosuggestions
}

wsl-ssh(){
    #wsl2-ssh-pageant
    mkdir -p $real_path/.ssh/
    destination="$real_path/.ssh/wsl2-ssh-pageant.exe"
    wget -O "$destination" "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe"
    # Set the executable bit.
    chmod +x "$destination"   
}

#install default stuff
install() {
    which $1 &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Installing: ${1}..." 
        apt install -y $1
    else
        echo "Already installed: ${1}"
    fi
}

#install everything
rootperm
zsh
spaceship
autosuggestions
if [ $wsl = 'y' ]; then wsl-ssh; fi

install python3-pip
install jq

#back to home
cd
exit

#reload shell
sudo -i -u $real_user chsh -s $(which zsh)
exec ${SHELL} -l
