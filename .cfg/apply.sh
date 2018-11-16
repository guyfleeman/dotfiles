#!/bin/bash

# load gnome terminal theme
dconf load /org/gnome/terminal/ < ~/.gnome_terminal

gsettings set org.gnome.desktop.interface gtk-theme "SolArc-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "SolArc-Dark"
gsettings set org.gnome.desktop.interface gtk-color-scheme "SolArc-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Arc"
