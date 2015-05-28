#!/bin/sh

LINK='ln --symbolic --relative --backup --suffix=.old'

$LINK bashrc ~/.bashrc
$LINK gitconfig ~/.gitconfig
$LINK profile ~/.profile
$LINK pythonrc ~/.pythonrc
$LINK tmux.conf ~/.tmux.conf
$LINK vimrc ~/.vimrc
