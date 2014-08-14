echo "Here we go!"



# this is the initial function
start () {
echo "Welcome: What OS are you using??"
read -p "Mac (m/M) or Linux (l/L) > " choice
case "$choice" in 
  m|M ) echo "Wooo! Mac!"
	Mac1;;
  l|L ) echo "Linux... Nice!"
  	stage5;;
  * ) echo "invalid entry!"
        start;;
esac
}



# ------- Linux Start ------- #


Linux1 () {
echo "Stage 1: install git, vim and zsh."
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) sudo apt-get update
  	sudo apt-get install git vim zsh
	echo "done";;
  n|N ) echo "Ok...";;
  * ) echo "invalid entry!"
        stage1;;
esac
}

Linux2 () {
echo "Stage 2: Generate ssh key?"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) ssh-keygen
	ssh-add ~/.ssh/id_rsa
	cat ~/.ssh/id_rsa
	echo "Now would be a good time to copy that to bitbucket or github..."
	;;
  n|N ) echo "Ok..."
	;;
  * ) echo "invalid entry!"
        stage2
	;;
esac
}

Linux3 () {
echo "Stage 3: Install vim plugins and fonts? (you need your ssh-key in github froggr...)"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) git clone git://github.com/froggr/vim.git ~/.vim
	ln -s ~/.vim/vimrc ~/.vimrc
	cd ~/.vim
	git submodule init
	git submodule update
	cd ~/
	git clone https://github.com/scotu/ubuntu-mono-powerline.git ~/.fonts
	fc-cache
	echo "Done. Vim should be good to go"
	;;
  n|N ) echo "Ok..."
	;;
  * ) echo "invalid entry!"
        stage3
	;;
esac
}

Linux4 () {
echo "Stage 4: Install oh-my-zsh? (you also may need your ssh-key in github froggr...)"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) curl -L http://install.ohmyz.sh | sh
	sed -i 's/ZSH_THEME="robbyrussel"/ZSH_THEME="bira"/g' ~/.zshrc
	echo "Done the install. If the theme wasn't changed to bira, vim the .zshrc file and change er'"
	;;
  n|N ) echo "Ok..."
	;;
  * ) echo "invalid entry!"
        stage4
	;;
esac
}

# -------- Linux End --------- #


# -------- Mac Start --------- #

Mac1 () {
echo "Mac -> Stage 1: Install Brew (you need your ssh-key in github froggr...)"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
	
	echo "Done the install."
	exit;;
  n|N ) echo "Ok..."
	;;
  * ) echo "invalid entry!"
        stage4
	;;
esac
}

# -------- Mac End --------- #



final () {
echo "Stage 5: Final misc. setup (projects dir, etc...)"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) mkdir ~/projects
	echo "Done!"
	;;
  n|N ) echo "Ok..."
	;;
  * ) echo "invalid entry!"
        stage5
	;;
esac
}


start

exit;
