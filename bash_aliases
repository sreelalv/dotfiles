#!/bin/bash

# Easier navigation: .., ..., ...., .....
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

#Navigate Directly from Home
cdd(){
	cd ; cd $1
}

remove_the_prompt(){
	[ -f ~/.bashrc ] && rm ~/.bashrc && "Removed : ~/.bashrc"
	[ -d ~/.dotfiles ] && rm -rf ~/.dotfiles && "Removed: ~/.dotfiles"
	[ -f ~/.bashrc.default ] && mv ~/.bashrc.default ~/.bashrc && echo "Default Prompt Restored"
	source ~/.bashrc
}

show_the_info(){
	echo "Usage : dotfiles [ info update remove ]"
}
update_the_prompt(){
	cd ~/.dotfiles && git pull origin master && mv .bashrc ~/.bashrc && cd - && echo "Update Successfull"
}

dotfiles(){
	if [[ "$1" = "info" ]];then
		show_the_info
	elif [[ "$1" = "update" ]]; then
		update_the_prompt
	elif [[ "$1" = "remove" ]]; then
		remove_the_prompt
	else
		show_the_info
	fi
}
