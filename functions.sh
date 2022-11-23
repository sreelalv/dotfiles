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
	if ! $(git -C ~/.dotfiles diff-files --quiet --ignore-submodules --); then
		git -C ~/.dotfiles stash save "saved preferences" && echo "Downloading Updates... " && git -C ~/.dotfiles pull origin master && git -C ~/.dotfiles stash pop -q && cp .bashrc ~/.bashrc && cd - && echo "Update Successfull"
	else
		echo "Downloading Updates... " && git -C ~/.dotfiles pull origin master && cp .bashrc ~/.bashrc && cd - && echo "Update Successfull"
	fi
}
restart_the_prompt(){
      	$(git -C ~/.dotfiles rev-parse --verify refs/stash &>/dev/null) && git -C ~/.dotfiles stash pop &>/dev/null ;
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
	fi
}
check_for_update(){
	eval 'git -C ~/.dotfiles fetch &>/dev/null'& disown -a 
	git -C ~/.dotfiles status -sb | grep behind &>/dev/null
	if (( $? == 0 )) ; then 
		echo "New update available for dotfiles"
		show_the_info
	fi
}
phone(){
	folder="/run/user/1000/gvfs/"
	if [[ $(ls $folder | wc -l) = 1 ]] ; then 
		cd  ${folder}*/ && ls ; 
	elif [[ $(ls $folder | wc -l) > 1 ]]; then 
		cd  ${folder} && ls ;
	fi
}
check_for_update








