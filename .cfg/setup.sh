#!/bin/sh

set -e

INIT_USER=$(whoami);

# prompt for root
[ "$INIT_USER" != "root" ] && exec sudo -- "$0" $INIT_USER "$@"

INIT_USER=$1

echo "Will install dotfiles for $INIT_USER"

# install packages
apt-get update -y
apt-get install $(grep -vE "^\s*#" packages.txt | tr "\n" " ") -y
if [ $? -ne 0 ]; then
	echo "apt-get install of gfm's packages failed. QUITTING."
	exit
fi

if [ `grep -c "$INIT_USER" /etc/passwd` -eq 0 ]; then
	echo "Unable to change shell. $INIT_USER not found in local user registery."
	echo "Is the machine on directory services?"
else
	# set Zsh default sh
	chsh -s $(which zsh) $INIT_USER
fi

# grab oh-my-zsh
if [ -d "/home/$INIT_USER/.oh-my-zsh" ]; then
	git --git-dir=/home/$INIT_USER/.oh-my-zsh/.git status > /dev/null
	if [ $? -ne 0 ]; then
		echo "Oh-My-Zsh exists but the repo is in an invalid state."
		echo "Will not clone."
	fi
else
	echo "No Oh-My-Zsh folder was found. Will run RR inst."
	sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
	git clone https://github.com/bhilburn/powerlevel9k.git /home/$INIT_USER/.oh-my-zsh/custom/themes/powerlevel9k
	chown -R $INIT_USER:$INIT_USER /home/$INIT_USER/.oh-my-zsh
	chown $INIT_USER:$INIT_USER /home/$INIT_USER/.zshrc
	chown $INIT_USER:$INIT_USER /home/$INIT_USER/.zsh-history

	# restore zshrc
	if [ -f $HOME/.zshrc.pre-oh-my-zsh ]; then
		mv $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc
	fi

	echo "Will perform one time install of powerline fonts."
	git clone https://github.com/powerline/fonts.git --depth=1
	cd fonts
	./install.sh
	cd ..
	rm -rf fonts
fi

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config submodule init
config submodule update --recursive

cd external/solarc
./autogen.sh --prefix /usr --disable-light --disable-xfwm --disable-cinnamon
make install
cd ../..

cd external/arcicon
./autogen.sh --prefix /usr
make install
cd ../..

cd external/xcbutil
git submodule update --init
./autogen.sh --prefix=/usr
make
make install
cd ../..

cd external/i3gaps
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
cd ../../..

cp kern_key_map.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable kern_key_map

