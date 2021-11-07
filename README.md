# dotfiles

## Usage

To clone and run this application, you'll need [Git](https://git-scm.com)

```bash
# Clone this repository in your home directory
$ git clone https://github.com/pimvandenbroek/dotfiles

# Make setup executable
$ chmod +x dotfiles/setup.sh

# Install script
$ sudo ./dotfiles/setup.sh
# If you are running on WSL2, and want to use existing sshkeys running in pageant, choose yes

# In some cases the shell isn't changed afterwards
$ chsh -s /usr/bin/zsh
```
