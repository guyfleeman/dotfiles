# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

#echo "doing cdm things"
# To avoid potential situation where cdm(1) crashes on every TTY, here we
# default to execute cdm(1) on tty1 only, and leave other TTYs untouched.
#if [[ "$(tty)" == '/dev/tty1' ]]; then
#    [[ -n "$CDM_SPAWN" ]] && return
#    # Avoid executing cdm(1) when X11 has already been started.
#    [[ -z "$DISPLAY$SSH_TTY$(pgrep xinit)" ]] && exec cdm
#fi


export QSYS_ROOTDIR="/home/guyfleeman/intelFPGA_lite/17.0/quartus/sopc_builder/bin"
