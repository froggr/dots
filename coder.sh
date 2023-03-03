#!/bin/bash

# disables the display of keyboard input
stty -echo

red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'
declare -i selection
selection=0
nodeMenu=1

menuOptions=(
"Run everything!"
"Install git, vim, zsh"
"Install Vim Powerline, Plugins and Fonts"
"Install Oh-My-Zsh"
"Insert ZSH Aliases for TMS Docker Compose"
"Init the repos!"
"Exit"
)

function allofem {
	git;;
	vimthemes;;
	ohmyzsh;;
	insertaliases;;
	repos;;
}

function git {
    clear
    sudo apt-get install git vim zsh
	echo "done!"
}

function vimthemes {
	clear
	echo "Do you need to generate an ssh key?"
    read -p "Start? (y/n) > " choice
    case "$choice" in 
        y|Y ) ssh-keygen
            ssh-add ~/.ssh/id_rsa
            cat ~/.ssh/id_rsa.pub
            echo "Now would be a good time to copy that to bitbucket or github..."
            read -p "Continue..."
            ;;
        n|N|* ) echo "Ok..."
            ;;
    esac

    git clone git://github.com/froggr/vim.git ~/.vim
	ln -s ~/.vim/vimrc ~/.vimrc
	cd ~/.vim
	git submodule init
	git submodule update
    open Inconsolata-dz-Powerline.otf
	cd ~/
	git clone https://github.com/scotu/ubuntu-mono-powerline.git ~/.fonts
	fc-cache
	echo "Done. Vim should be good to go"

}

function ohmyzsh {
	clear

    curl -L http://install.ohmyz.sh | sh
	curl -o ~/.oh-my-zsh/themes/frog.zsh-theme 'https://raw.githubusercontent.com/froggr/dots/master/files/frog.zsh-theme'
	sed -i.bu 's/robbyrussell/frog/g' ~/.zshrc
	sed -i.bu 's/plugins\(git\)/plugins\=\(git docker docker-compose zsh-syntax-highlighting zsh-autosuggestions\)/g' ~/.zshrc
	echo "alias ll=\"ls -la\"" >> ~/.zshrc
	sudo chsh -s $(which zsh) $USER
	brew install fzf
	$(brew --prefix)/opt/fzf/install
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	
	echo "Done the install. If the theme wasnt changed to bira, vim the .zshrc file and change er"    
}

function insertaliases {
	echo "Here we go..."
cat <<EOT >> ~/.zshrc
    alias dcshell="docker compose -p tms_docker-compose --project-directory /var/www/html exec app bash"
    alias dcmysql="docker compose -p tms_docker-compose exec app bash -c 'mysql -uroot -ppassword -h db'"
    alias php7="sudo update-alternatives --set php /usr/bin/php7.4"
    alias php8="sudo update-alternatives --set php /usr/bin/php8.2"

    dc() {
        docker compose -p tms_docker-compose $*
    }

    dcnpm() {
        docker compose -p tms_docker-compose exec app bash -c "cd /var/www/html && npm $*"
    }

    artisan() {
        docker compose -p tms_docker-compose exec app bash -c "cd /var/www/html && php artisan $*"
    }
EOT

}

function repos {
    mkdir ~/projects && cd ~/projects
    git clone git@github.com:timelessgroup/TMS_docker-compose.git
    git clone git@github.com:Timeless-Medical-International/Version-7-Laravel.git
    git clone https://github.com/timelessgroup/Version-7
    cp ~/projects/TMS_docker-compose/example_env ~/projects/TMS_docker-compose/.env
}
                                                                                                                   

function menu {
    
        echo -e "${grn}"                                                                               
        echo -e "Frogs Dots!"
        echo -e "${end}"
        echo -e "\t${yel}Select a menu option and hit return:${end}\n"
       
}

# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

# takes an array and loads the menu
function select_opt {
    select_option "$@" 1>&2
    local result=$?
    echo $result
    return $result
}



while [ 1 ]
do
    clear
	menu
	case `select_opt "${menuOptions[@]}"` in
	    0)
        allofem ;;
        
        1)
        git ;;

        2)
		vimthemes ;;

		3)
		ohmyzsh ;;

		4)
		insertaliases ;;

        5)
        repos ;;

		6)
		break;;

	esac
    echo -e "\n\n"
    read -r -s -p $'Press enter to continue...'
done
clear





# https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu
# this is awesome
