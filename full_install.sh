#!/bin/sh

## Script to install tmux,zsh,oh-my-zsh
echo "=============================="
echo -e "\n\nInstalling packages ..."
echo "=============================="

formulas="vim
    tmux
    tree
    wget
    zsh
"

 if cat /etc/*release | grep ^NAME | grep CentOS; then
    echo "==============================================="
    echo "Installing packages $formulas on CentOS"
    echo "==============================================="
    yum install -y $formulas
 elif cat /etc/*release | grep ^NAME | grep Red; then
    echo "==============================================="
    echo "Installing packages $formulas on RedHat"
    echo "==============================================="
    yum install -y $formulas
 elif cat /etc/*release | grep ^NAME | grep Fedora; then
    echo "================================================"
    echo "Installing packages $formulas on Fedorea"
    echo "================================================"
    yum install -y $formulas
 elif cat /etc/*release | grep ^NAME | grep Ubuntu; then
    echo "==============================================="
    echo "Installing packages $formulas on Ubuntu"
    echo "==============================================="
    apt-get update
    apt-get install -y $formulas
 elif cat /etc/*release | grep ^NAME | grep Debian ; then
    echo "==============================================="
    echo "Installing packages $formulas on Debian"
    echo "==============================================="
    apt-get update
    apt-get install -y $formulas
 elif cat /etc/*release | grep ^NAME | grep Mint ; then
    echo "============================================="
    echo "Installing packages $formulas on Mint"
    echo "============================================="
    apt-get update
    apt-get install -y $formulas
 elif cat /etc/*release | grep ^NAME | grep Knoppix ; then
    echo "================================================="
    echo "Installing packages $formulas on Kanoppix"
    echo "================================================="
    apt-get update
    apt-get install -y $formulas
 elif uname -s | grep Darwin ; then
    echo "================================================="
    echo "Installing packages $formulas on Mac OS"
    echo "================================================="
    brew update
    brew install $formulas
 else
    echo "OS NOT DETECTED, couldn't install package $formulas"
    exit 1;
 fi

echo "================================================="
echo "Installing packages Oh-my-zsh"
echo "================================================="
# Installing oh-my-zsh within a script. Source: https://github.com/robbyrussell/oh-my-zsh/issues/5873
sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch || {
    echo "Could not install Oh My Zsh" >/dev/stderr
    exit 1
}


echo "================================================="
echo "Symlink zsh theme, tmux.conf, vimrc, zshrc"
echo "================================================="

 DOTFILES=$HOME/.ide_config

 echo "Symlinking dotfiles"
 ln -s $DOTFILES/zsh/oh-my-zsh/themes/spaceship.zsh-theme.symlink ~/.oh-my-zsh/themes/spaceship.zsh-theme
 ln -s $DOTFILES/tmux/tmux.conf.symlink ~/.tmux.conf
 ln -s $DOTFILES/vim/vimrc.symlink ~/.vimrc
 ln -s $DOTFILES/zsh/zshrc.symlink ~/.zshrc


echo "================================================="
echo "Installing packages vundle and activate plugins"
echo "================================================="

# Install Vundle if it is not installed
echo
if [ ! -d $HOME/.vim/bundle/Vundle.vim ]
then
    echo "Installing Vundle"
    sudo mv $HOME/.vim $HOME/.vim.old
    mkdir -p $HOME/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
else
    echo "Vundle already installed"
fi

# This hack removes the Vim UI output
# Source: https://github.com/VundleVim/Vundle.vim/issues/511
echo "Installing Vundle plugins"
echo | echo | vim +PluginInstall +qall &>/dev/null