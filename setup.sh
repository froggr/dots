echo "Here we go!"


mac () {
echo "Welcome: Are you on a mac?"
read -p "Start? (y/n) > " choice
case "$choice" in 
  y|Y ) echo "Cool. Exiting!"
	exit;;
  n|N ) echo "Ok..."
  	stage1;;
  * ) echo "invalid entry!"
        mac;;
esac
}

stage1 () {
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

stage2 () {
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

stage3 () {
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

stage4 () {
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

stage5 () {
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

cd ~/
mac
stage1
stage2
stage3
stage4
stage5

echo "all done! later!"

