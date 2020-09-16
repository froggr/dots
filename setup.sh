echo "Here we go!"



# this is the initial function
start () {
echo "Welcome: What OS are you using??"
read -p "Mac (m/M) or Linux (l/L) > " choice
case "$choice" in 
  m|M ) echo "Wooo! Mac!"
	Mac0;;
  l|L ) echo "Linux... Nice!"
  	Linux1;;
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
		echo "done"
		Linux2;;
  n|N ) echo "Ok..."
		Linux2;;
  * ) echo "invalid entry!"
      Linux1;;
esac
}

Linux2 () {
echo "Stage 2: Generate ssh key?"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) ssh-keygen
	ssh-add ~/.ssh/id_rsa
	cat ~/.ssh/id_rsa.pub
	echo "Now would be a good time to copy that to bitbucket or github..."
	Linux3;;
  n|N ) echo "Ok..."
	Linux3;;
  * ) echo "invalid entry!"
        Linux2
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
	final1;;
  n|N ) echo "Ok..."
	final1;;
  * ) echo "invalid entry!"
        Linux3
	;;
esac
}


# -------- Linux End ---------


# -------- Mac Start ---------

Mac0 () {
echo "Stage 2: Generate ssh key?"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) ssh-keygen
	ssh-add ~/.ssh/id_rsa
	cat ~/.ssh/id_rsa.pub
	echo "Now would be a good time to copy that to bitbucket or github..."
	Mac1;;
  n|N ) echo "Ok..."
	Mac1;;
  * ) echo "invalid entry!"
        Mac0
	;;
esac
}

Mac1 () {
echo "Mac -> Stage 1: Install Brew (you need your ssh-key in github froggr...)"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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
echo "Mac -> Stage 2: Install Vim plugins and fonts? (you need your ssh-key in github froggr...)"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) git clone git://github.com/froggr/vim.git ~/.vim
	ln -s ~/.vim/vimrc ~/.vimrc
	ln -s ~/.vim/gvimrc ~/.gvimrc
	cd ~/.vim
	git submodule init
	git submodule update
	open Inconsolata-dz-Powerline.otf
	cd ~/
	echo "Done. MacVim should be good to go. You will need to install the powerline font that just opened."
	Mac3;;
  n|N ) echo "Ok..."
	Mac3;;
  * ) echo "invalid entry!"
        Mac2
	;;
esac
}


Mac3 () {
echo "Mac -> Stage 3: Install docker and docker-compose, iterm, google chrome, vscode...)"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) brew cask install docker
	brew cask install iterm
	brew cask install google-chrome
	brew cask install visual-studio-code
	final1;;
  n|N ) echo "Ok..."
	final1;;
  * ) echo "invalid entry!"
        Mac3
	;;
esac
}



# -------- Mac End ---------


final1 () {
echo "Stage 4: Install oh-my-zsh?"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) curl -L http://install.ohmyz.sh | sh
	curl -o ~/.oh-my-zsh/themes/frog.zsh-theme 'https://cdn.rawgit.com/froggr/dots/master/files/frog.zsh-theme'
	sed -i.bu 's/robbyrussell/frog/g' ~/.zshrc
	sed -i.bu 's/plugins\(git\)/plugins\=\(git docker docker-compose zsh-syntax-highlighting zsh-autosuggestions\)/g' ~/.zshrc
	echo "alias ll=\"ls -la\"" >> ~/.zshrc
	chsh -s $(which zsh)
	brew install fzf
	$(brew --prefix)/opt/fzf/install
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	
	
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
