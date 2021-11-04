#!/bin/bash

echo 'Setup for wsl or not (y/n):'
read wsl

#Check root privilege.
rootperm(){
    log "Checking root"
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

updatepackages(){
    log "Updating packages"
    apt update -y > /dev/null 2>&1;
}

movefiles(){
    sudo -i -u $real_user cp -r $real_path/dotfiles/. $real_path/.
    rm -rf .git
}

#log function
log(){
    date +"[%Y-%m-%d %H:%M:%S] ${1}"
}

#zsh
zsh() {
    log "Installing zsh"
    apt install zsh -y > /dev/null 2>&1;
}

#spaceship
spaceship() {
    log "Installing spaceship-prompt"
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git --depth=1 > /dev/null 2>&1;
    sudo -i -u $real_user mkdir .zfunctions
    cd $real_path/spaceship-prompt
    ln -sf "$PWD/spaceship.zsh" "/usr/local/share/zsh/site-functions/prompt_spaceship_setup" > /dev/null 2>&1;
    fpath=( "${ZDOTDIR:-$real_path}/.zfunctions" $fpath ) > /dev/null 2>&1;
    ln -sf "$PWD/spaceship.zsh" "${ZDOTDIR:-$real_path}/.zfunctions/prompt_spaceship_setup" > /dev/null 2>&1;
}

#zsh-autosuggestions
autosuggestions(){
    log "Installing autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions $real_path/.zsh/zsh-autosuggestions > /dev/null 2>&1;
}

wsl-ssh(){
    install socat
    install iproute2
    log "Installing wsl-ssh"
    #wsl2-ssh-pageant
    sudo -i -u $real_user mkdir -p $real_path/.ssh/
    destination="$real_path/.ssh/wsl2-ssh-pageant.exe"
    wget -O "$destination" "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe" > /dev/null 2>&1;
    # Set the executable bit.
    chown $real_user:$real_user "$destination"
    chmod +x "$destination"   
}

#install default stuff
install() {
    which $1 &> /dev/null
    if [ $? -ne 0 ]; then
        log "Installing ${1}"
        apt install -y $1 > /dev/null 2>&1;
    else
        echo "Already installed: ${1}"
    fi
}

#install everything
updatepackages
rootperm
movefiles
zsh
spaceship
autosuggestions
if [ $wsl = 'y' ]; then wsl-ssh; fi

install nano
install python3-pip
install jq

#back to home
cd

#reload shell
chsh -s $(which zsh)
exit
