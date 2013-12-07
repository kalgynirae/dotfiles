#!/bin/sh

LINK='ln --symbolic --relative --backup --suffix=.old'

LINK bashrc ~/.bashrc
LINK gitconfig ~/.gitconfig
mkdir -p ~/.config/i3/
LINK i3config ~/.config/i3/config
LINK pythonrc ~/.pythonrc
LINK vimrc ~/.vimrc
LINK xinitrc ~/.xinitrc
