#!/bin/bash

echo 'Setup for wsl or not (y/n):'
read wsl

sudo apt update -y > /dev/null 2>&1;

#Check root privilege.
rootperm(){
    echo "Checking root"|date +"[%Y-%m-%d %H:%M:%S]"
    if [ "$(id -u)" -ne 0 ]; then
        error "You must be root"
	    exit 1
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
    cd spaceship-prompt
    ln -sf "$PWD/spaceship.zsh" "/usr/local/share/zsh/site-functions/prompt_spaceship_setup"
    fpath=( "${ZDOTDIR:-$HOME}/.zfunctions" $fpath )
    cd spaceship-prompt
    ln -sf "$PWD/spaceship.zsh" "${ZDOTDIR:-$HOME}/.zfunctions/prompt_spaceship_setup"
}

#zsh-autosuggestions
autosuggestions(){
    echo "Installing autosuggestions"|date +"[%Y-%m-%d %H:%M:%S]"   
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
}

wsl-ssh(){
    #wsl2-ssh-pageant
    destination="$HOME/.ssh/wsl2-ssh-pageant.exe"
    wget -O "$destination" "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe"
    # Set the executable bit.
    chmod +x "$destination"   
}

#install default stuff
install() {
    which $1 &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Installing: ${1}..."|date +"[%Y-%m-%d %H:%M:%S]"   
        apt install -y $1
    else
        echo "Already installed: ${1}"|date +"[%Y-%m-%d %H:%M:%S]"   
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

#reload shell
chsh -s $(which zsh)
exec ${SHELL} -l
