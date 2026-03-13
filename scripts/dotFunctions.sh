#! /bin/bash
#Navigate Directly from Home

remove_the_prompt(){
	sudo bash -c "[[ -L /root/.bashrc ]] && rm /root/.bashrc" >/dev/null 2>&1 && echo "Removed : /root/.bashrc" 
	[ -h ~/.bashrc ] && rm  ~/.bashrc && echo "Removed : ~/.bashrc"
	[ -d $_dot_path ] && rm -rf $_dot_path && echo "Removed: $_dot_path"
	[ -f ~/.bashrc.default ] && mv ~/.bashrc.default ~/.bashrc 
	echo -e  "Default Prompt Restored\n\n"
	exec bash
}
show_the_info(){
	echo "Usage : bashdots [ info update restart remove ]"
}

update_the_prompt(){
	if ! $(git -C $_dot_path diff-files --quiet --ignore-submodules --); then
		git -C $_dot_path stash save "saved preferences" && echo "Downloading Updates... " && git -C $_dot_path pull origin master && git -C $_dot_path stash pop -q &&  echo "Update Successfull" && exec bash
	else
		echo "Downloading Updates... " && git -C $_dot_path pull origin master && echo "Update Successfull" && exec bash
	fi
}
restart_the_prompt(){
    $(git -C $_dot_path rev-parse --verify refs/stash &>/dev/null) && git -C $_dot_path stash pop &>/dev/null ;
	source ~/.bashrc && exec bash
}
bashdots(){
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
	((git -C $_dot_path fetch &>/dev/null)&)  
	git -C $_dot_path status -sb | grep behind &>/dev/null
	if (( $? == 0 )) ; then 
		echo "New update available for bashDots"
		show_the_info
	fi
}
check_for_update








