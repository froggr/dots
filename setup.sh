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



# ------- Linux Start -------


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


# -------- Linux End ---------


# -------- Mac Start ---------

Mac1 () {
echo "Mac -> Stage 1: Install Brew (you need your ssh-key in github froggr...)"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
	echo "Done the install."
	Mac2;;
  n|N ) echo "Ok..."
	Mac2;;
  * ) echo "invalid entry!"
        Mac1
	;;
esac
}


Mac2 () {
echo "Mac -> Stage 2: Install MacVim plugins and fonts? (you need your ssh-key in github froggr...)"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) brew install macvim --override-system-vim
  	git clone git://github.com/froggr/vim.git ~/.vim
	ln -s ~/.vim/vimrc ~/.vimrc
	cd ~/.vim
	git submodule init
	git submodule update
	open Inconsolata-dz-Powerline.otf
	cd ~/
	echo "Done. MacVim should be good to go. You will need to install the powerline font that just opened."
	final1;;
  n|N ) echo "Ok..."
	final1;;
  * ) echo "invalid entry!"
        Mac2
	;;
esac
}

# -------- Mac End ---------


final1 () {
echo "Stage 4: Install oh-my-zsh?"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) curl -L http://install.ohmyz.sh | sh
	sed -i.bu 's/robbyrussell/bira/g' ~/.zshrc
	echo "alias ll=\"ls -la\"" >> ~/.zshrc
	echo "Done the install. If the theme wasnt changed to bira, vim the .zshrc file and change er"
	final2;;
  n|N ) echo "Ok..."
	final2;;
  * ) echo "invalid entry!"
        final1
	;;
esac
}

final2 () {
echo "Do you want to alias vim for mvim? Only if youre using a mac!!"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) 	echo "alias vim=\"mvim\" >> ~/.zshrc"
	echo "Done!"
	final3;;
  n|N ) echo "Ok..."
	  final3;;
  * ) echo "invalid entry!"
        final2
	;;
esac
}




final3 () {
echo "Stage 5: Final misc. setup (projects dir, etc…)"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) mkdir ~/projects
	echo "Done!"
	;;
  n|N ) echo "Ok..."
	;;
  * ) echo "invalid entry!"
        final3
	;;
esac
}



start

echo "Ok! Installation is complete! Cheers"

exit;
