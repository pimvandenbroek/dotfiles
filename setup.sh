#!/bin/bash

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

#zsh-autosuggestions
autosuggestions(){
    log "Installing autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions $real_path/.zsh/zsh-autosuggestions > /dev/null 2>&1;
}

#starship
starship() {
    log "Installing starship"
    curl -sS https://starship.rs/install.sh | sh
    mv .starship.toml ~/.config/starship.toml
}

#eza
setupeza() {
    log "Installing eza"
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
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

install nano
install python3-pip
install jq
install tmux
install gpg

setupeza

#back to home
cd

#reload shell
chsh -s /usr/bin/zsh
exit
