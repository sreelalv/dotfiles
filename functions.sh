#! /bin/bash
#Navigate Directly from Home

cdd(){
	cd ; cd $1
}
remove_the_prompt(){
	[ -h ~/.bashrc ] && rm  ~/.bashrc && echo "Removed : ~/.bashrc"
	[ -d ~/.dotfiles ] && rm -rf ~/.dotfiles && echo "Removed: ~/.dotfiles"
	[ -f ~/.bashrc.default ] && mv ~/.bashrc.default ~/.bashrc 
	echo -e  "Default Prompt Restored\n\n"
	exec bash
}
show_the_info(){
	echo "Usage : dotfiles [ info update restart remove ]"
}

update_the_prompt(){
	if ! $(git -C ~/.dotfiles diff-files --quiet --ignore-submodules --); then
		git -C ~/.dotfiles stash save "saved preferences" && echo "Downloading Updates... " && git -C ~/.dotfiles pull origin master && git -C ~/.dotfiles stash pop -q &&  echo "Update Successfull" && exec bash
	else
		echo "Downloading Updates... " && git -C ~/.dotfiles pull origin master && echo "Update Successfull" && exec bash
	fi
}
restart_the_prompt(){
    $(git -C ~/.dotfiles rev-parse --verify refs/stash &>/dev/null) && git -C ~/.dotfiles stash pop &>/dev/null ;
	source ~/.bashrc && exec bash
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
		show_the_info
		restart_the_prompt
	fi
}
check_for_update(){
	((git -C ~/.dotfiles fetch &>/dev/null)&)  
	git -C ~/.dotfiles status -sb | grep behind &>/dev/null
	if (( $? == 0 )) ; then 
		echo "New update available for dotfiles"
		show_the_info
	fi
}
check_for_update








