#! /bin/bash
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
	echo "Usage : dotfiles [ info update restart remove ]"
}

update_the_prompt(){
	cd ~/.dotfiles
	if ! $(git diff-files --quiet --ignore-submodules --); then
		git stash save "saved preferences" && git pull origin master && git stash pop -q && cp .bashrc ~/.bashrc && cd - && echo "Update Successfull"
	else
		cd ~/.dotfiles && git pull origin master && cp .bashrc ~/.bashrc && cd - && echo "Update Successfull"
	fi
}
restart_the_prompt(){
	cd ~/.dotfiles ;
      	$(git rev-parse --verify refs/stash &>/dev/null) && git stash pop &>/dev/null ;
       	cd - >/dev/null
	source ~/.bashrc
}
dotfiles(){
	if [[ "$1" = "info" ]];then
		show_the_info
	elif [[ "$1" = "update" ]]; then
		update_the_prompt
	elif [[ "$1" = "restart" ]]; then
		restart_the_prompt
	elif [[ "$1" = "remove" ]]; then
		remove_the_prompt
	else
		restart_the_prompt
		show_the_info
	fi
}
