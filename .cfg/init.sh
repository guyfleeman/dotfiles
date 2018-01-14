#!/bin/sh
INIT_USER=$(whoami);

# prompt for root
[ "$INIT_USER" != "root" ] && exec sudo -- "$0" "$@"

# install packages
apt-get update -y
apt-get install $(grep -vE "^\s*#" packages.txt | tr "\n" " ") -y
if [ $? -ne 0 ]; then
	echo "apt-get install of gfm's packages failed. QUITTING."
	exit
fi

# set Zsh default sh
chsh -s $(which zsh) $INIT_USER

# grab oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
	git --git-dir=$HOME/.oh-my-zsh --work-tree=$HOME/.oh-my-zsh status
	if [ $? -ne 0 ]; then
		echo "Oh-My-Zsh exists but the repo is in an invalid state."
		echo "Will not clone."
	fi
else
	echo "No Oh-My-Zsh folder was found. Will run RR inst."
	sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
	git clone https://github.com/bhilburn/powerlevel9k.git $HOME/.oh-my-zsh/custom/themes/powerlevel9k
	chown -R $INIT_USER:$INIT_USER $HOME/.oh-my-zsh
	chown $INIT_USER:$INIT_USER $HOME/.zshrc
	chown $INIT_USER:$INIT_USER $HOME/.zsh-history

	echo "Will perform one time install of powerline fonts."
	git clone https://github.com/powerline/fonts.git --depth=1
	cd fonts
	./install.sh
	cd ..
	rm -rf fonts
fi


